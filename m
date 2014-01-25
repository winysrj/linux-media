Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58051 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaAYPXp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 10:23:45 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0M0xbD-1VIYUb1OEJ-00vA9X for
 <linux-media@vger.kernel.org>; Sat, 25 Jan 2014 16:23:42 +0100
Date: Sat, 25 Jan 2014 16:23:40 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140125152339.GA18168@minime.bse>
References: <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
 <20140121101950.GA13818@minime.bse>
 <52DECF44.1070609@googlemail.com>
 <52DEDFCB.6010802@googlemail.com>
 <20140122115334.GA14710@minime.bse>
 <52DFC300.8010508@googlemail.com>
 <20140122135036.GA14871@minime.bse>
 <52E00AD0.2020402@googlemail.com>
 <20140123132741.GA15756@minime.bse>
 <52E1273F.90207@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <52E1273F.90207@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 02:29:19PM +0000, Robert Longbottom wrote:
> Jan 23 14:24:48 quad kernel: [154562.493224] bits: FMTCHG* VSYNC
> HSYNC OFLOW FBUS   NUML => 625
> Jan 23 14:24:49 quad kernel: [154562.994015] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:49 quad kernel: [154563.496010] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:50 quad kernel: [154563.997020] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:50 quad kernel: [154564.498018] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:51 quad kernel: [154564.999023] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:51 quad kernel: [154565.500024] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:52 quad kernel: [154566.001014] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
> Jan 23 14:24:52 quad kernel: [154566.502016] bttv: 0: timeout:
> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW

The chip didn't lock to the input signal.
What kind of input are you feeding into the card?

Can you run the attached program while xawtv is running?
It will dump most of the registers of the bt8xx video function.

  Daniel

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dumpbt8xx.c"

#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char path[100], *fname;

#define BT848	(1 << 0)
#define BT848A	(1 << 1)
#define BT878	(1 << 2)
#define SINCE_BT878	BT878
#define SINCE_BT848A	SINCE_BT878 | BT848A
#define SINCE_BT848	SINCE_BT848A | BT848

static const struct {
	uint16_t offset;
	uint16_t chips;
	const char *name;
} regs[] = {
	0x000, SINCE_BT848, "DSTATUS",
	0x004, SINCE_BT848, "IFORM",
	0x008, SINCE_BT848, "TDEC",
	0x00C, SINCE_BT848, "E_CROP",
	0x010, SINCE_BT848, "E_VDELAY_LO",
	0x014, SINCE_BT848, "E_VACTIVE_LO",
	0x018, SINCE_BT848, "E_HDELAY_LO",
	0x01C, SINCE_BT848, "E_HACTIVE_LO",
	0x020, SINCE_BT848, "E_HSCALE_HI",
	0x024, SINCE_BT848, "E_HSCALE_LO",
	0x028, SINCE_BT848, "BRIGHT",
	0x02C, SINCE_BT848, "E_CONTROL",
	0x030, SINCE_BT848, "CONTRAST_LO",
	0x034, SINCE_BT848, "SAT_U_LO",
	0x038, SINCE_BT848, "SAT_V_LO",
	0x03C, SINCE_BT848, "HUE",
	0x040, SINCE_BT848, "E_SCLOOP",
	0x044, SINCE_BT848, "WC_UP",
	0x048, SINCE_BT848, "OFORM",
	0x04C, SINCE_BT848, "E_VSCALE_HI",
	0x050, SINCE_BT848, "E_VSCALE_LO",
	0x054, SINCE_BT848, "TEST",
	0x058, SINCE_BT878, "ARESET",
	0x060, SINCE_BT848, "ADELAY",
	0x064, SINCE_BT848, "BDELAY",
	0x068, SINCE_BT848, "ADC",
	0x06C, SINCE_BT848, "E_VTC",
	0x078, SINCE_BT848, "WC_DOWN",
	0x080, SINCE_BT848A, "TGLB",
	0x084, SINCE_BT848A, "TGCTRL",
	0x08C, SINCE_BT848, "O_CROP",
	0x090, SINCE_BT848, "O_VDELAY_LO",
	0x094, SINCE_BT848, "O_VACTIVE_LO",
	0x098, SINCE_BT848, "O_HDELAY_LO",
	0x09C, SINCE_BT848, "O_HACTIVE_LO",
	0x0A0, SINCE_BT848, "O_HSCALE_HI",
	0x0A4, SINCE_BT848, "O_HSCALE_LO",
	0x0AC, SINCE_BT848, "O_CONTROL",
	0x0B0, SINCE_BT848, "VTOTAL_LO",
	0x0B4, SINCE_BT848, "VTOTAL_HI",
	0x0C0, SINCE_BT848, "O_SCLOOP",
	0x0CC, SINCE_BT848, "O_VSCALE_HI",
	0x0D0, SINCE_BT848, "O_VSCALE_LO",
	0x0D4, SINCE_BT848, "COLOR_FMT",
	0x0D8, SINCE_BT848, "COLOR_CTL",
	0x0DC, SINCE_BT848, "CAP_CTL",
	0x0E0, SINCE_BT848, "VBI_PACK_SIZE",
	0x0E4, SINCE_BT848, "VBI_PACK_DEL",
	0x0E8, SINCE_BT848A, "FCAP",
	0x0EC, SINCE_BT848, "O_VTC",
	0x0F0, SINCE_BT848A, "PLL_F_LO",
	0x0F4, SINCE_BT848A, "PLL_F_HI",
	0x0F8, SINCE_BT848A, "PLL_XCI",
	0x0FC, SINCE_BT848A, "DVSIF",
	0x100, SINCE_BT848, "INT_STAT",
	0x104, SINCE_BT848, "INT_MASK",
	0x10C, SINCE_BT848, "GPIO_DMA_CTL",
	0x110, SINCE_BT848, "I2C",
	0x114, SINCE_BT848, "RISC_STRT_ADD",
	0x118, SINCE_BT848, "GPIO_OUT_EN",
	0x11C, SINCE_BT848, "GPIO_REG_INP",
	0x120, SINCE_BT848, "RISC_COUNT",
	0x200, SINCE_BT848, "GPIO_DATA",
};

#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))

static long get_attr(const char *attr)
{
	char name[80], buf[20] = {0};
	int fd;

	strcpy(fname, attr);
	fd = open(path, O_RDONLY);
	if (fd == -1) {
		perror("open");
		return -1;
	}
	read(fd, buf, sizeof(buf) - 1);
	close(fd);
	return strtol(buf, NULL, 0);
}

static uint32_t get_config(unsigned int offset)
{
	uint8_t buf[4];
	ssize_t n;
	int fd;

	strcpy(fname, "config");
	fd = open(path, O_RDONLY);
	if (fd == -1) {
		perror("open");
		return 0;
	}
	n = pread(fd, buf, 4, offset);
	close(fd);
	if (n != 4) {
		perror("pread");
		return 0;
	}
	return (buf[3] << 24) + (buf[2] << 16) + (buf[1] << 8) + buf[0];
}

int main(int argc, char **argv)
{
	int fd, i, chip;
	uint32_t *p;
	struct stat st;

	if (argc != 2) {
		fprintf(stderr, "%s /dev/videoX\n", argv[0]);
		return 1;
	}
	if (stat(argv[1], &st)) {
		perror("stat");
		return 1;
	}
	if (!S_ISCHR(st.st_mode) || major(st.st_rdev) != 81) {
		fprintf(stderr, "%s is not a video device\n", argv[1]);
		return 1;
	}
	fname = path + sprintf(path, "/sys/dev/char/81:%i/device/", minor(st.st_rdev));
	if (get_attr("vendor") != 0x109e) {
bad_chip:
		fputs("Not a bt8xx device\n", stderr);
		return 1;
	}

	switch (get_attr("device")) {
	case 0x0350:
		if ((get_config(8) & 0xff) == 0x12)
			chip = BT848A;
		else
			chip = BT848;
		break;
	case 0x0351:
		chip = BT848A;
		break;
	case 0x036e:
	case 0x036f:
	case 0x036c:
		chip = BT878;
		break;
	default:
		goto bad_chip;
	}

	strcpy(fname, "resource0");
       	fd = open(path, O_RDWR|O_SYNC);
	if (fd == -1)
		return 1;
	p = mmap(NULL, 0x1000, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (p == MAP_FAILED)
		return 1;
	for (i = 0; i < ARRAY_SIZE(regs); i++) {
		if (chip & regs[i].chips)
			printf("%03X %08X %s\n", regs[i].offset,
			       p[regs[i].offset / 4], regs[i].name);
	}
	return 0;
}

--yrj/dFKFPuw6o+aM--
