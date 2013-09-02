Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60565 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757612Ab3IBAjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Sep 2013 20:39:13 -0400
Message-ID: <1378082350.25743.60.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 1/4] [media] lirc_bt829: Make it a proper PCI driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 02 Sep 2013 01:39:10 +0100
In-Reply-To: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
References: <1378082213.25743.58.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bFPPkdey525TI/K2becS"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-bFPPkdey525TI/K2becS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Replace static variables with a device structure and pass pointers
to this into all the functions that need it.

Fold init_module(), do_pci_probe() and atir_init_start() into a
single probe function.  Use dev_err() to provide context for
logging.

This also fixes a device reference leak, as the driver wasn't
calling pci_dev_put().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/media/lirc/lirc_bt829.c | 276 +++++++++++++++++-----------=
----
 1 file changed, 144 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/medi=
a/lirc/lirc_bt829.c
index fa31ee7..c277bf3 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -30,25 +30,32 @@
=20
 #include <media/lirc_dev.h>
=20
-static int poll_main(void);
-static int atir_init_start(void);
+struct atir_device {
+	int minor;
+	unsigned char *pci_addr_lin;
+	struct lirc_driver driver;
+};
=20
-static void write_index(unsigned char index, unsigned int value);
-static unsigned int read_index(unsigned char index);
+static int poll_main(struct atir_device *atir);
=20
-static void do_i2c_start(void);
-static void do_i2c_stop(void);
+static void write_index(struct atir_device *atir, unsigned char index,
+			unsigned int value);
+static unsigned int read_index(struct atir_device *atir, unsigned char ind=
ex);
=20
-static void seems_wr_byte(unsigned char al);
-static unsigned char seems_rd_byte(void);
+static void do_i2c_start(struct atir_device *atir);
+static void do_i2c_stop(struct atir_device *atir);
=20
-static unsigned int read_index(unsigned char al);
-static void write_index(unsigned char ah, unsigned int edx);
+static void seems_wr_byte(struct atir_device *atir, unsigned char al);
+static unsigned char seems_rd_byte(struct atir_device *atir);
+
+static unsigned int read_index(struct atir_device *atir, unsigned char al)=
;
+static void write_index(struct atir_device *atir, unsigned char ah,
+			unsigned int edx);
=20
 static void cycle_delay(int cycle);
=20
-static void do_set_bits(unsigned char bl);
-static unsigned char do_get_bits(void);
+static void do_set_bits(struct atir_device *atir, unsigned char bl);
+static unsigned char do_get_bits(struct atir_device *atir);
=20
 #define DATA_PCI_OFF 0x7FFC00
 #define WAIT_CYCLE   20
@@ -62,41 +69,12 @@ static bool debug;
 			printk(KERN_DEBUG DRIVER_NAME ": "fmt, ## args); \
 	} while (0)
=20
-static int atir_minor;
-static unsigned long pci_addr_phys;
-static unsigned char *pci_addr_lin;
-
-static struct lirc_driver atir_driver;
-
-static struct pci_dev *do_pci_probe(void)
-{
-	struct pci_dev *my_dev;
-	my_dev =3D pci_get_device(PCI_VENDOR_ID_ATI,
-				PCI_DEVICE_ID_ATI_264VT, NULL);
-	if (my_dev) {
-		pr_err("Using device: %s\n", pci_name(my_dev));
-		pci_addr_phys =3D 0;
-		if (my_dev->resource[0].flags & IORESOURCE_MEM) {
-			pci_addr_phys =3D my_dev->resource[0].start;
-			pr_info("memory at 0x%08X\n",
-			       (unsigned int)pci_addr_phys);
-		}
-		if (pci_addr_phys =3D=3D 0) {
-			pr_err("no memory resource ?\n");
-			return NULL;
-		}
-	} else {
-		pr_err("pci_probe failed\n");
-		return NULL;
-	}
-	return my_dev;
-}
-
 static int atir_add_to_buf(void *data, struct lirc_buffer *buf)
 {
+	struct atir_device *atir =3D data;
 	unsigned char key;
 	int status;
-	status =3D poll_main();
+	status =3D poll_main(atir);
 	key =3D (status >> 8) & 0xFF;
 	if (status & 0xFF) {
 		dprintk("reading key %02X\n", key);
@@ -117,172 +95,191 @@ static void atir_set_use_dec(void *data)
 	dprintk("driver is closed\n");
 }
=20
-int init_module(void)
+static int atir_pci_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *entry)
 {
-	struct pci_dev *pdev;
-
-	pdev =3D do_pci_probe();
-	if (pdev =3D=3D NULL)
-		return -ENODEV;
-
-	if (!atir_init_start())
-		return -ENODEV;
-
-	strcpy(atir_driver.name, "ATIR");
-	atir_driver.minor       =3D -1;
-	atir_driver.code_length =3D 8;
-	atir_driver.sample_rate =3D 10;
-	atir_driver.data        =3D 0;
-	atir_driver.add_to_buf  =3D atir_add_to_buf;
-	atir_driver.set_use_inc =3D atir_set_use_inc;
-	atir_driver.set_use_dec =3D atir_set_use_dec;
-	atir_driver.dev         =3D &pdev->dev;
-	atir_driver.owner       =3D THIS_MODULE;
-
-	atir_minor =3D lirc_register_driver(&atir_driver);
-	if (atir_minor < 0) {
-		pr_err("failed to register driver!\n");
-		return atir_minor;
+	struct atir_device *atir;
+	unsigned long pci_addr_phys;
+	int rc;
+
+	atir =3D kzalloc(sizeof(*atir), GFP_KERNEL);
+	if (!atir)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, atir);
+
+	if (!(pdev->resource[0].flags & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "no memory resource ?\n");
+		rc =3D -ENODEV;
+		goto err_free;
 	}
-	dprintk("driver is registered on minor %d\n", atir_minor);
=20
-	return 0;
-}
+	pci_addr_phys =3D pdev->resource[0].start;
+	dev_info(&pdev->dev, "memory at 0x%08X\n",
+		 (unsigned int)pci_addr_phys);
=20
+	atir->pci_addr_lin =3D ioremap(pci_addr_phys + DATA_PCI_OFF, 0x400);
+	if (atir->pci_addr_lin =3D=3D 0) {
+		dev_err(&pdev->dev, "pci mem must be mapped\n");
+		rc =3D -ENODEV;
+		goto err_free;
+	}
=20
-void cleanup_module(void)
-{
-	lirc_unregister_driver(atir_minor);
+	strcpy(atir->driver.name, "ATIR");
+	atir->driver.minor       =3D -1;
+	atir->driver.code_length =3D 8;
+	atir->driver.sample_rate =3D 10;
+	atir->driver.data        =3D atir;
+	atir->driver.add_to_buf  =3D atir_add_to_buf;
+	atir->driver.set_use_inc =3D atir_set_use_inc;
+	atir->driver.set_use_dec =3D atir_set_use_dec;
+	atir->driver.dev         =3D &pdev->dev;
+	atir->driver.owner       =3D THIS_MODULE;
+
+	atir->minor =3D lirc_register_driver(&atir->driver);
+	if (atir->minor < 0) {
+		dev_err(&pdev->dev, "failed to register driver!\n");
+		rc =3D atir->minor;
+		goto err_free;
+	}
+	dprintk("driver is registered on minor %d\n", atir->minor);
+
+	return 0;
+
+err_free:
+	pci_set_drvdata(pdev, NULL);
+	kfree(atir);
+	return rc;
 }
=20

-static int atir_init_start(void)
+static void atir_pci_remove(struct pci_dev *pdev)
 {
-	pci_addr_lin =3D ioremap(pci_addr_phys + DATA_PCI_OFF, 0x400);
-	if (pci_addr_lin =3D=3D 0) {
-		pr_info("pci mem must be mapped\n");
-		return 0;
-	}
-	return 1;
+	struct atir_device *atir =3D pci_get_drvdata(pdev);
+
+	lirc_unregister_driver(atir->minor);
+	pci_set_drvdata(pdev, NULL);
+	kfree(atir);
 }
=20
+
 static void cycle_delay(int cycle)
 {
 	udelay(WAIT_CYCLE*cycle);
 }
=20

-static int poll_main(void)
+static int poll_main(struct atir_device *atir)
 {
 	unsigned char status_high, status_low;
=20
-	do_i2c_start();
+	do_i2c_start(atir);
=20
-	seems_wr_byte(0xAA);
-	seems_wr_byte(0x01);
+	seems_wr_byte(atir, 0xAA);
+	seems_wr_byte(atir, 0x01);
=20
-	do_i2c_start();
+	do_i2c_start(atir);
=20
-	seems_wr_byte(0xAB);
+	seems_wr_byte(atir, 0xAB);
=20
-	status_low =3D seems_rd_byte();
-	status_high =3D seems_rd_byte();
+	status_low =3D seems_rd_byte(atir);
+	status_high =3D seems_rd_byte(atir);
=20
-	do_i2c_stop();
+	do_i2c_stop(atir);
=20
 	return (status_high << 8) | status_low;
 }
=20
-static void do_i2c_start(void)
+static void do_i2c_start(struct atir_device *atir)
 {
-	do_set_bits(3);
+	do_set_bits(atir, 3);
 	cycle_delay(4);
=20
-	do_set_bits(1);
+	do_set_bits(atir, 1);
 	cycle_delay(7);
=20
-	do_set_bits(0);
+	do_set_bits(atir, 0);
 	cycle_delay(2);
 }
=20
-static void do_i2c_stop(void)
+static void do_i2c_stop(struct atir_device *atir)
 {
 	unsigned char bits;
-	bits =3D  do_get_bits() & 0xFD;
-	do_set_bits(bits);
+	bits =3D  do_get_bits(atir) & 0xFD;
+	do_set_bits(atir, bits);
 	cycle_delay(1);
=20
 	bits |=3D 1;
-	do_set_bits(bits);
+	do_set_bits(atir, bits);
 	cycle_delay(2);
=20
 	bits |=3D 2;
-	do_set_bits(bits);
+	do_set_bits(atir, bits);
 	bits =3D 3;
-	do_set_bits(bits);
+	do_set_bits(atir, bits);
 	cycle_delay(2);
 }
=20
-static void seems_wr_byte(unsigned char value)
+static void seems_wr_byte(struct atir_device *atir, unsigned char value)
 {
 	int i;
 	unsigned char reg;
=20
-	reg =3D do_get_bits();
+	reg =3D do_get_bits(atir);
 	for (i =3D 0; i < 8; i++) {
 		if (value & 0x80)
 			reg |=3D 0x02;
 		else
 			reg &=3D 0xFD;
=20
-		do_set_bits(reg);
+		do_set_bits(atir, reg);
 		cycle_delay(1);
=20
 		reg |=3D 1;
-		do_set_bits(reg);
+		do_set_bits(atir, reg);
 		cycle_delay(1);
=20
 		reg &=3D 0xFE;
-		do_set_bits(reg);
+		do_set_bits(atir, reg);
 		cycle_delay(1);
 		value <<=3D 1;
 	}
 	cycle_delay(2);
=20
 	reg |=3D 2;
-	do_set_bits(reg);
+	do_set_bits(atir, reg);
=20
 	reg |=3D 1;
-	do_set_bits(reg);
+	do_set_bits(atir, reg);
=20
 	cycle_delay(1);
-	do_get_bits();
+	do_get_bits(atir);
=20
 	reg &=3D 0xFE;
-	do_set_bits(reg);
+	do_set_bits(atir, reg);
 	cycle_delay(3);
 }
=20
-static unsigned char seems_rd_byte(void)
+static unsigned char seems_rd_byte(struct atir_device *atir)
 {
 	int i;
 	int rd_byte;
 	unsigned char bits_2, bits_1;
=20
-	bits_1 =3D do_get_bits() | 2;
-	do_set_bits(bits_1);
+	bits_1 =3D do_get_bits(atir) | 2;
+	do_set_bits(atir, bits_1);
=20
 	rd_byte =3D 0;
 	for (i =3D 0; i < 8; i++) {
 		bits_1 &=3D 0xFE;
-		do_set_bits(bits_1);
+		do_set_bits(atir, bits_1);
 		cycle_delay(2);
=20
 		bits_1 |=3D 1;
-		do_set_bits(bits_1);
+		do_set_bits(atir, bits_1);
 		cycle_delay(1);
=20
-		bits_2 =3D do_get_bits();
+		bits_2 =3D do_get_bits(atir);
 		if (bits_2 & 2)
 			rd_byte |=3D 1;
=20
@@ -293,15 +290,15 @@ static unsigned char seems_rd_byte(void)
 	if (bits_2 =3D=3D 0)
 		bits_1 |=3D 2;
=20
-	do_set_bits(bits_1);
+	do_set_bits(atir, bits_1);
 	cycle_delay(2);
=20
 	bits_1 |=3D 1;
-	do_set_bits(bits_1);
+	do_set_bits(atir, bits_1);
 	cycle_delay(3);
=20
 	bits_1 &=3D 0xFE;
-	do_set_bits(bits_1);
+	do_set_bits(atir, bits_1);
 	cycle_delay(2);
=20
 	rd_byte >>=3D 1;
@@ -309,10 +306,10 @@ static unsigned char seems_rd_byte(void)
 	return rd_byte;
 }
=20
-static void do_set_bits(unsigned char new_bits)
+static void do_set_bits(struct atir_device *atir, unsigned char new_bits)
 {
 	int reg_val;
-	reg_val =3D read_index(0x34);
+	reg_val =3D read_index(atir, 0x34);
 	if (new_bits & 2) {
 		reg_val &=3D 0xFFFFFFDF;
 		reg_val |=3D 1;
@@ -321,36 +318,36 @@ static void do_set_bits(unsigned char new_bits)
 		reg_val |=3D 0x20;
 	}
 	reg_val |=3D 0x10;
-	write_index(0x34, reg_val);
+	write_index(atir, 0x34, reg_val);
=20
-	reg_val =3D read_index(0x31);
+	reg_val =3D read_index(atir, 0x31);
 	if (new_bits & 1)
 		reg_val |=3D 0x1000000;
 	else
 		reg_val &=3D 0xFEFFFFFF;
=20
 	reg_val |=3D 0x8000000;
-	write_index(0x31, reg_val);
+	write_index(atir, 0x31, reg_val);
 }
=20
-static unsigned char do_get_bits(void)
+static unsigned char do_get_bits(struct atir_device *atir)
 {
 	unsigned char bits;
 	int reg_val;
=20
-	reg_val =3D read_index(0x34);
+	reg_val =3D read_index(atir, 0x34);
 	reg_val |=3D 0x10;
 	reg_val &=3D 0xFFFFFFDF;
-	write_index(0x34, reg_val);
+	write_index(atir, 0x34, reg_val);
=20
-	reg_val =3D read_index(0x34);
+	reg_val =3D read_index(atir, 0x34);
 	bits =3D 0;
 	if (reg_val & 8)
 		bits |=3D 2;
 	else
 		bits &=3D 0xFD;
=20
-	reg_val =3D read_index(0x31);
+	reg_val =3D read_index(atir, 0x31);
 	if (reg_val & 0x1000000)
 		bits |=3D 1;
 	else
@@ -359,26 +356,41 @@ static unsigned char do_get_bits(void)
 	return bits;
 }
=20
-static unsigned int read_index(unsigned char index)
+static unsigned int read_index(struct atir_device *atir, unsigned char ind=
ex)
 {
 	unsigned char *addr;
 	unsigned int value;
 	/*  addr =3D pci_addr_lin + DATA_PCI_OFF + ((index & 0xFF) << 2); */
-	addr =3D pci_addr_lin + ((index & 0xFF) << 2);
+	addr =3D atir->pci_addr_lin + ((index & 0xFF) << 2);
 	value =3D readl(addr);
 	return value;
 }
=20
-static void write_index(unsigned char index, unsigned int reg_val)
+static void write_index(struct atir_device *atir, unsigned char index,
+			unsigned int reg_val)
 {
 	unsigned char *addr;
-	addr =3D pci_addr_lin + ((index & 0xFF) << 2);
+	addr =3D atir->pci_addr_lin + ((index & 0xFF) << 2);
 	writel(reg_val, addr);
 }
=20
+static DEFINE_PCI_DEVICE_TABLE(atir_pci_table) =3D {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_264VT) },
+	{ 0 }
+};
+
+static struct pci_driver atir_pci_driver =3D {
+	.name		=3D KBUILD_MODNAME,
+	.id_table	=3D atir_pci_table,
+	.probe		=3D atir_pci_probe,
+	.remove		=3D atir_pci_remove,
+};
+module_pci_driver(atir_pci_driver);
+
 MODULE_AUTHOR("Froenchenko Leonid");
 MODULE_DESCRIPTION("IR remote driver for bt829 based TV cards");
 MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, atir_pci_table);
=20
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");



--=-bFPPkdey525TI/K2becS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUiPeLue/yOyVhhEJAQoEZhAAz3BQaHR6CpRPPV5MtdPIEo6as4Ok5T9Q
+VrUsAjtKR4r6y9bgB8IsdmqPWrGJIwle35ex+VqQUpShXBg0hhKgDda5ulVroov
zOT3NxweUfBReyOW+r4+7IhPxsYLiMPc2kSMg7mbY364JAReAFL1axDz5woUT9VF
srdRhkfJ7PQg/eEB4ivmlIwHOm+ycdM/VR17FNzIpp8w5AdtMmbguxs7wlaTVzH+
2MdKi0fgHu9qKIGKNYeCnbcAJ+JcQ4dSvCISyzUFdnIycRvDYquSRzbK1+PtSS6h
BHaGwtzQx0ZK4YOnIUzBx6iiLmZJRCmGtqYIuVIXGYidee2cP7BAM3eTZDww80Aq
Ol1iVmVmKT+NznPCyJXKDRrqnU/QS6yOx3mZa2RGHVOwF8WZA6SZCciSNyK4SVnr
/eIIUSf9BPwuTPS8QH0amTEqZYBcABXDWYOw0v3Ygt4rWPbTzJYHTNbN5G+cRBD9
fqrg95vxzxxn2+WCNuLxieL/kejVYb/1SzpA3iiOVFN5f5wBZ15Y091Lc0BClA2k
944U40mZuF4HZmvbFwOtqsPe7OmPrCF49U4DktpXI221ty2P3wFff6tyetqQ8hcW
P1//GMs9mPhLkkZ0xtSC52wtgaLFb+mfFsMoEjN5bthihxZ1XSNf2odsM7F7GwFd
UI52odhs4uo=
=S8gu
-----END PGP SIGNATURE-----

--=-bFPPkdey525TI/K2becS--
