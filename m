Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42428 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbZAXBam (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 20:30:42 -0500
Subject: Re: [RFC] Need testers for s5h1409 tuning fix
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
References: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
	 <1232733940.3907.37.camel@palomino.walls.org>
	 <412bdbff0901231136l6967b5bbj8a3cfd4832ab102e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 20:31:18 -0500
Message-Id: <1232760678.3907.77.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-23 at 14:36 -0500, Devin Heitmueller wrote:

> 
> It would be good if you could provide some actual data regarding
> before and after the patch.  Typically I run Kaffeine from the command
> line, which prints out the tuning time to stdout.  For example, here
> are the times Robert saw when he tested my patch:
> 
> Before the change:
> Tuning delay: 2661 ms
> Tuning delay: 474 ms
> Tuning delay: 472 ms
> Tuning lock fail after 5000ms
> Tuning delay: 2000 ms
> Tuning delay: 2685 ms
> Tuning delay: 475 ms
> 
> After the change:
> Tuning delay: 594 ms
> Tuning delay: 570 ms
> Tuning delay: 574 ms
> Tuning delay: 671 ms
> Tuning delay: 570 ms
> Tuning delay: 673 ms
> 
> If you could provide something comparable, it would be useful.

For OTA ATSC 8-VSB with an HVR-1600 MCE:

Without the change:

$ ./tune
Commanding tune to freq 479028615 ... FE_HAS_LOCK in 1.416984 seconds.
Commanding tune to freq 551028615 ... FE_HAS_LOCK in 1.389922 seconds.
Commanding tune to freq 569028615 ... FE_HAS_LOCK in 2.783927 seconds.
Commanding tune to freq 587028615 ... FE_HAS_LOCK in 1.391952 seconds.
Commanding tune to freq 593028615 ... NO lock after 2.999655 seconds.
Commanding tune to freq 599028615 ... FE_HAS_LOCK in 1.568240 seconds.
Commanding tune to freq 605028615 ... FE_HAS_LOCK in 1.390964 seconds.
Commanding tune to freq 623028615 ... NO lock after 2.999656 seconds.
Commanding tune to freq 677028615 ... FE_HAS_LOCK in 2.963289 seconds.
Commanding tune to freq 695028615 ... NO lock after 2.999618 seconds.

With the change:

$ ./tune
Commanding tune to freq 479028615 ... FE_HAS_LOCK in 1.323542 seconds.
Commanding tune to freq 551028615 ... FE_HAS_LOCK in 1.293956 seconds.
Commanding tune to freq 569028615 ... FE_HAS_LOCK in 1.292931 seconds.
Commanding tune to freq 587028615 ... FE_HAS_LOCK in 1.292973 seconds.
Commanding tune to freq 593028615 ... FE_HAS_LOCK in 1.292920 seconds.
Commanding tune to freq 599028615 ... FE_HAS_LOCK in 1.293977 seconds.
Commanding tune to freq 605028615 ... FE_HAS_LOCK in 1.292940 seconds.
Commanding tune to freq 623028615 ... FE_HAS_LOCK in 1.292949 seconds.
Commanding tune to freq 677028615 ... FE_HAS_LOCK in 1.293948 seconds.
Commanding tune to freq 695028615 ... NO lock after 2.999659 seconds.


No lock was expected for 695 MHz in either case - it was known negative.

Since I was to lazy to get Kaffeine to work properly, I wrote my own
test app.  It is inline below so you can see how I measured the time.

Regards,
Andy

/*
 * tune.c - Measure the time to tune some hardcoded ATSC OTA channels
 * Copyright (C) 2009 Andy Walls
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Author: Andy Walls <awalls@radix.net>
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/select.h>
#include <errno.h>
#include <sys/time.h>
#include <linux/dvb/frontend.h>

unsigned int test_freq[] = {
	479028615,
	551028615,
	569028615,
	587028615,
	593028615,
	599028615,
	605028615,
	623028615,
	677028615,
	695028615,
	0
};

int main(int argc, char *argv[])
{
	int fd, ret, i;
	struct dtv_property task[3];
	struct dtv_properties tasks;

	struct timeval tv, stv, etv;
	int n, watch;
	fd_set efds;
	struct dvb_frontend_event fev;

	fd = open("/dev/dvb/adapter0/frontend0", O_RDWR|O_NONBLOCK);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	tasks.props = task;

	/* Basic ATSC 8-VSB setup */
	task[0].cmd = DTV_DELIVERY_SYSTEM;
	task[0].u.data = SYS_ATSC;
	task[0].result = 0;
	task[1].cmd = DTV_MODULATION;
	task[1].u.data = VSB_8;
	task[1].result = 0;
	tasks.num = 2;

	ret = ioctl(fd, FE_SET_PROPERTY, &tasks);
	if (ret < 0) {
		perror("FE_SET_PROPERTY");
		close(fd);
		exit(2);
	}
	
	ret = 0;
	for(i = 0; i < tasks.num; i++) {
		if (task[i].result < 0)
			ret = task[i].result;
	}

	if (ret < 0) {
		fprintf(stderr, "Failed to set ATSC 8-VSB modulation.\n");
		close(fd);
		exit(3);
	}

	/* Tune test loop */
	task[0].cmd = DTV_FREQUENCY;
	task[1].cmd = DTV_TUNE;
	task[1].u.data = 0;

	for(i = 0; test_freq[i] != 0; i++) {
		/* Tune to next freq */
		task[0].u.data = test_freq[i];
		task[0].result = 0;
		task[1].result = 0;
		tasks.num = 2;
		printf("Commanding tune to freq %u ... ", task[0].u.data);
		gettimeofday(&stv, NULL);
		ret = ioctl(fd, FE_SET_PROPERTY, &tasks);
		if (ret < 0 || task[0].result < 0 || task[1].result < 0) {
			putchar('\n');
			perror("FE_SET_PROPERTY");
			fprintf(stderr, "failed commanding tune to freq %u\n",
				task[0].u.data);
			continue;
		}

		/* Look for a frontend LOCK */
		watch = 1;
		while (watch) {
			FD_ZERO(&efds);
			FD_SET(fd, &efds);
			tv.tv_sec = 3;
			tv.tv_usec = 0;
			n = select(fd+1, NULL, NULL, &efds, &tv);
			if (n < 0) {
				if (errno == EINTR)
					continue;
				putchar('\n');
				perror("select");
				fprintf(stderr,
					"error waiting for a frontend event\n");
				break;
			}
			if (n == 0) {
				gettimeofday(&etv, NULL);
				if (stv.tv_usec > etv.tv_usec) {
					etv.tv_sec -= 1;
					etv.tv_usec += 1000000;
				}
				etv.tv_usec -= stv.tv_usec;
				etv.tv_sec -= stv.tv_sec;
				printf("NO lock after %u.%06u seconds.\n",
					etv.tv_sec, etv.tv_usec);
				break;
			}

			/* Pull off all the frontend events */
			fev.status = (fe_status_t) 0;
			etv.tv_sec = 0; etv.tv_usec = 0;
			while (1) {
				ret = ioctl(fd, FE_GET_EVENT, &fev);
				if (ret < 0) {
					if (errno == EOVERFLOW) {
						/* overflow warning */
						continue;
					}
					if (errno == EWOULDBLOCK) {
						/* event queue is empty now */
						break;
					}
					/* bad error, stop waiting for events */
					putchar('\n');
					perror("FE_GET_EVENT");
					watch = 0;
					break;
				}

				/* Scan for the first LOCK status */
				if (!watch || !(fev.status & FE_HAS_LOCK))
					continue;

				gettimeofday(&etv, NULL);
				if (stv.tv_usec > etv.tv_usec) {
					etv.tv_sec -= 1;
					etv.tv_usec += 1000000;
				}
				etv.tv_usec -= stv.tv_usec;
				etv.tv_sec -= stv.tv_sec;
				printf("FE_HAS_LOCK in %u.%06u seconds.\n",
					etv.tv_sec, etv.tv_usec);
				watch = 0;
			}
		}
	}
	close(fd);
	exit(0);
}


