Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50964 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaBKNiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 08:38:09 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MHX0m-1WC7bX1O72-003Kmb for
 <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 14:38:07 +0100
Date: Tue, 11 Feb 2014 14:38:05 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140211133805.GA26402@minime.bse>
References: <20140123132741.GA15756@minime.bse>
 <52E1273F.90207@googlemail.com>
 <20140125152339.GA18168@minime.bse>
 <52E4EFBB.7070504@googlemail.com>
 <20140126125552.GA26918@minime.bse>
 <52E5366A.807@googlemail.com>
 <20140127032044.GA27541@minime.bse>
 <52E6C7A4.8050708@googlemail.com>
 <20140128020242.GA31019@minime.bse>
 <5679652F-05AC-44B8-AE0B-A107E38F2433@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5679652F-05AC-44B8-AE0B-A107E38F2433@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Feb 05, 2014 at 01:16:53PM +0000, Robert Longbottom wrote:
> On 28 Jan 2014, at 02:02 AM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> > When we cycle through all combinations in one minute, there are about
> > a hundred PCI cycles per combination left for the chip to be granted
> > access to the bus. I expect most of the pins to provide a priority
> > or weighting value for each BT878A, so there should be many combinations
> > that do something.
> 
> How difficult is it for me to do this?  And is it obvious when it works?
> I have an old pc that I can put the card in that doesn't matter. And given
> I can't get the card to work in windows or Linux its not much use to me as
> it is, so if it breaks then so be it. 
> 
> I've not done any Linux driver development, but I'm happy enough compiling
> stuff for the most part.

Try the attached program. It must be linked with -lrt. It will set all 24
GPIOs of that one chip to output. The output file contains one nibble
per GPIO combination with each bit representing one of the BT878.

In my tests with a single BT878 the 10us delay sometimes was not enough
for the RISC PC to advance. It should be enough to recognize a pattern,
though.

  Daniel


DMA from userspace... I feel dirty...

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trybt8xxgpio.c"

#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <signal.h>
#include <time.h>
#include <sched.h>
#include <string.h>
#include <limits.h>
#include <dirent.h>

#ifndef MAP_32BIT
#if defined(__x86_64__) || defined(__i386__)
#define MAP_32BIT 0x40
#else
#define MAP_32BIT 0
#endif
#endif

#define BT848_RISC_JUMP	(0x07 << 28)

static char path[PATH_MAX] = "/sys/bus/pci/devices/", *fname;

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

static int find_card(void)
{
	int i = strlen(path), j, n = 0;
	DIR *d = opendir(path), *d2;
	struct dirent *e;
	char *busdev, lastgood[PATH_MAX];

	if (!d)
		return 0;
	while ((e = readdir(d))) {
		if (e->d_name[0] == '.')
			continue;
		strcpy(path + i, e->d_name);
		strcat(path, "/");
		fname = path + strlen(path);
		if (get_attr("vendor") != 0x3388)
			continue;
		if (get_attr("device") != 0x0021)
			continue;
		strcpy(fname, "pci_bus");
		d2 = opendir(path);
		if (!d2)
			continue;
		while (e = readdir(d2)) {
			if (e->d_name[0] == '.')
				continue;
			strcpy(path + i, e->d_name);
			break;
		}
		closedir(d2);
		if (!e)
			continue;
		fname = path + strlen(path) + 6;
		for (j = 0xC; j <= 0xF; j++) {
			sprintf(fname - 6, ":%02x.0/", j);
			if (access(path, F_OK))
				break;
			if (get_attr("vendor") != 0x109e)
				break;
			if (get_attr("device") != 0x036e)
				break;
		}
		if (j < 0x10)
			continue;
		fname[0] = 0;
		strcpy(lastgood, path);
		n++;
	}
	closedir(d);
	if (!n)
		fputs("card not found\n", stderr);
	else if (n > 1)
		fputs("multiple cards found, can't decide which to test\n",
		      stderr);
	else {
		strcpy(path, lastgood);
		fname = path + strlen(path);
		strcpy(fname, "resource0");
		fname -= 4;
	}
	return n == 1;
}

static void *get_page(uint32_t *phys)
{
	long l = sysconf(_SC_PAGESIZE);
	void *m;
	int fd;
	uintptr_t v;
	uint64_t p;

	m = mmap(NULL, l, PROT_READ|PROT_WRITE,
		 MAP_PRIVATE|MAP_ANONYMOUS|MAP_32BIT|MAP_LOCKED, -1, 0);
	if (m == MAP_FAILED)
		return NULL;
	v = (uintptr_t)m;
	if (v % l)
		return NULL;
	v /= l;

	fd = open("/proc/self/pagemap", O_RDONLY);
	if (fd == -1)
		return NULL;
	if (pread(fd, &p, sizeof(p), v * sizeof(p)) != sizeof(p))
		return NULL;
	close(fd);
	if ((p >> 62) != 2)
		return NULL;
	p = (p & ((1LL << 55) - 1)) << ((p >> 55) & 0x3f);
	if (p >> 32)
		return NULL;
	*phys = p;
	return m;
}

static unsigned int loops;

static void delay(void)
{
	unsigned int n;
	for(n = loops; n--;)
		asm volatile("");
}

static void calibrate_delay(void)
{
	struct sched_param p = { .sched_priority = 1 };
	struct timespec pre, post;
	unsigned long long ll;

	printf("Calibrating delay loop...\n");
	sched_setscheduler(0, SCHED_FIFO, &p);
	clock_gettime(CLOCK_MONOTONIC, &pre);

	loops = 100000000;
	delay();

	clock_gettime(CLOCK_MONOTONIC, &post);
	p.sched_priority = 0;
	sched_setscheduler(0, SCHED_OTHER, &p);

	ll =  post.tv_sec - pre.tv_sec;
	ll *= 1000000000;
	ll += post.tv_nsec;
	ll -= pre.tv_nsec;
	if (ll > 10000)
		loops = loops * 10000ULL / ll;

	printf("Using %u loops for 10us\n", loops);
}

static uint32_t *bt[4];
static uint8_t result[(1 << 24) / 2];

static uint32_t *openbt8xx(char dev)
{
	void *p;
	int fd;

	*fname = dev;
	fd = open(path, O_RDWR|O_SYNC);
	if (fd == -1)
		return NULL;
	p = mmap(NULL, 0x1000, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (p == MAP_FAILED)
		return NULL;
	return p;
}

static void stoprisc(int sig)
{
	int i;
	for (i = 4; i--;)
		bt[i][0x10C/4] = 0;
	if (sig)
		_exit(1);
}

static void usage(const char *self)
{
	fprintf(stderr, "$ %s <outfile>\n", self);
}

int main(int argc, char **argv)
{
	uint32_t *riscv, riscp;
	uint32_t gpio, n;
	int i, v, fd;

	if (!argv[1]) {
		usage(argv[0]);
		return 1;
	}

	fd = open(argv[1], O_WRONLY|O_CREAT|O_TRUNC, 0666);

	riscv = get_page(&riscp);
	if (!riscv)
		return 1;
	riscv[0] = BT848_RISC_JUMP;
	riscv[1] = riscp + 8;
	riscv[2] = BT848_RISC_JUMP;
	riscv[3] = riscp + 8;
	if (!find_card())
		return 1;
	for (i = 4; i--;) {
		bt[i] = openbt8xx('c' + i);
		if (!bt[i]) {
			fputs("Failed to open MMIO region\n", stderr);
			return 1;
		}
	}

	calibrate_delay();

	signal(SIGTERM, stoprisc);
	signal(SIGINT, stoprisc);
	signal(SIGQUIT, stoprisc);
	signal(SIGABRT, stoprisc);
	signal(SIGHUP, stoprisc);
	for (i = 4; i--;) {
		bt[i][0x10C/4] = 0;
		bt[i][0xDC/4] = 0;
		bt[i][0x114/4] = riscp;
	}
	bt[1][0x118/4] = 0xffffff;

	v = 0;
	for (n = 1 << 24; n--;) {
		// use Gray code to avoid actions based on intermediate values
		gpio = n ^ (n >> 1);
		bt[1][0x200/4] = gpio;
		for (i = 4; i--;)
			bt[i][0x10C/4] = 3;
		delay();
		if (!(n & 0x0fffff))
			printf("%u%% left\n", (n * 100) >> 24);
		for (i = 4; i--;) {
			if (bt[i][0x120/4] != riscp) {
				bt[i][0x10C/4] = 0;
				v += 1 << i;
			}
		}
		if (gpio & 1)
			v <<= 4;
		result[gpio >> 1] |= v;
		v = 0;
	}
	stoprisc(0);
	write(fd, result, sizeof(result));
	gpio = 0;
	for(n = sizeof(result); n--;) {
		if (result[n] & 0xf0)
			gpio++;
		if (result[n] & 0x0f)
			gpio++;
	}
	printf("Found %u combinations with RISC instuction fetches\n", gpio);
	return 0;
}

--17pEHd4RhPHOinZp--
