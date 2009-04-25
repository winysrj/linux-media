Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3PB03db021192
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 07:00:03 -0400
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3PAxlUp030854
	for <video4linux-list@redhat.com>; Sat, 25 Apr 2009 06:59:47 -0400
Received: from webmail.xs4all.nl (dovemail2.xs4all.nl [194.109.26.4])
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id n3PAxk8D026345
	for <video4linux-list@redhat.com>;
	Sat, 25 Apr 2009 12:59:47 +0200 (CEST)
	(envelope-from avdongen@xs4all.nl)
Message-ID: <53984.80.101.132.146.1240657187.squirrel@webmail.xs4all.nl>
Date: Sat, 25 Apr 2009 12:59:47 +0200 (CEST)
From: "Arthur van Dongen" <avdongen@xs4all.nl>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: mantis driver (jusst.de) selects wrong tuner on Terratec Cinergy C
 PCI
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

(I don't know if this is the right location to report this issue, if not
please point me to the right location)

Previously I ran kernel 2.6.28.1 (stock kernel on Debian AMD64) with the
Mantis driver from jusst.de/hg/mantis/ and it worked OK with my Terratec
Cinergy C PCI.

After upgrading to stock kernel 2.6.29.1 I compiled the mantis-v4l driver
from jusst.de/hg/mantis-v4l but it could not find any channel. Searching
in old mailing lists showed that the mantis driver selects the tda10021
tuner, where it should have loaded the tda20023 tuner.

I made two hacks to the mantis-v4l source files, to make it work for my
card. I won't provide proper patch output because it will break other
cards and I don't have enough knowledge to do the right runtime selection.

In mantis_cards.c I changed the mantis_pci_table struct.

static struct pci_device_id mantis_pci_table[] = {
(...)
        //MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
        MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
};

In mantis_vp2040.c I removed the probe for the TDA10021 tuner, so it
defaults to the TDA10023.

static int vp2040_frontend_init(struct mantis_pci *mantis, struct
dvb_frontend *fe)
{
        struct i2c_adapter *adapter = &mantis->adapter;

        int err = 0;

        err = mantis_frontend_power(mantis, POWER_ON);
        if (err == 0) {
                mantis_frontend_soft_reset(mantis);
                msleep(250);

                dprintk(MANTIS_ERROR, 1, "Probing for CU1216 (DVB-C)");
                fe = 0; //dvb_attach(tda10021_attach,
                        //      &vp2040_tda1002x_cu1216_config,
                        //      adapter,
                        //      read_pwm(mantis));

                if (fe) {
                        dprintk(MANTIS_ERROR, 1,
                                "found Philips CU1216 DVB-C frontend
(TDA10021) @ 0x%02x",
                                vp2040_tda1002x_cu1216_config.demod_address);
                } else {
                        fe = dvb_attach(tda10023_attach,
                                        &vp2040_tda10023_cu1216_config,
                                        adapter,
                                        read_pwm(mantis));


I hope the V4L experts can use this hack to make a fix that will work for
all cards. Maybe just reverse the checks for the two tuner types?

Best regards,
Arthur van Dongen

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
