Return-path: <mchehab@pedra>
Received: from mail-bw0-f52.google.com ([209.85.214.52]:59431 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1EVMrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 08:47:37 -0400
Received: by bwj24 with SMTP id 24so6115993bwj.11
        for <linux-media@vger.kernel.org>; Sun, 22 May 2011 05:47:35 -0700 (PDT)
Date: Sun, 22 May 2011 14:48:15 +0200 (CEST)
From: Martin Vidovic <xtronom@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
In-Reply-To: <201105112059.21083@orion.escape-edv.de>
Message-ID: <alpine.LNX.2.00.1105221330580.16386@mvdev.cyberevil.net>
References: <4D74E28A.6030302@gmail.com> <201105112059.21083@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Oliver,

On Wed, 11 May 2011, Oliver Endriss wrote:

> On Monday 07 March 2011 14:50:02 Martin Vidovic wrote:
> > ...
> > - SEC device generates NULL packets (ad infinitum):
> > 
> > When reading from SEC, NULL packets are read and interleaved with 
> > expected packets. They can be even read with dd(1) when nobody is 
> > writing to SEC and even when CAM is not ready.
> > ...
> 
> I reworked the driver to strip those null packets. Please try
> http://linuxtv.org/hg/~endriss/ngene-octopus-test/raw-rev/f0dc4237ad08
> 

a) Tested without CAM, it works OK.
b) Tested with Viaccess Pocket dTV, there are some problems:

Sometimes filtering works, sometimes it doesn't. This summarises the 
observed behaviour:

(1) When I read 188 bytes from SEC, I notice first byte isn't 0x47. So, I
    count how many bytes need to be skipped to get to the 0x47 byte. For 
    illustration, let's say 8 bytes need to be skipped.

(2) Now I do CA_RESET ioctl on matching CA device and wait 3 seconds.

(3) Repeat step (1) but now I count 4 bytes need to be skipped.

(4) Do CA_RESET.

(5) NULL packets can't be read now.

(6) Do CA_RESET.

(7) Repeat step (1) and now 184 bytes need to be skipped.

(8) and so on...

Here is the code I used for testing:

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>

#include <linux/dvb/ca.h>

#include <stdio.h>

#define NUM_PKT 672
#define BUF_SIZE (NUM_PKT * 188)

int fd_ca = -1;
int fd_sec = -1;

unsigned char *buf_in = NULL;

pthread_t read_thread;

int err(const char *msg) {
	printf("ERROR: %s (%m).\n", msg);
	return 1;
}

void *read_thread_main(void *tparm) {
	ssize_t n_read = 0;
	size_t prev_sync_off = 0;
	size_t prev_sync_diff = 0;
	size_t i = 0;

	while (1) {
		n_read = read(fd_sec, buf_in, BUF_SIZE);
		if (n_read > 0) {
			printf("[%zd b]: ", n_read);

			prev_sync_off = 0;
			for (i = 1; i < n_read; i++) {
				if (buf_in[i] == 0x47) {

					/* measure distance between two sync bytes */
					if ((i - prev_sync_off) != prev_sync_diff) {
						prev_sync_diff = (i - prev_sync_off);
						printf("%zu @ %zu; ", prev_sync_diff, i);
					}

					prev_sync_off = i;
				}
			}

			printf("\n");
		} else if (n_read < 0) {
			printf("SEC read error '%m'.\n");
			break;
		}
	}

	return NULL;
}

int main(int argc, char **argv) {
	char path_ca[] = "/dev/dvb/0123456789abcdef/ca0";
	char path_sec[] = "/dev/dvb/0123456789abcdef/sec0";

	/* make dev paths + malloc buffers */

	if (argc != 2) {
		printf("usage: %s adapter_name\n", argv[0]);
		return 1;
	}

	if (strlen(argv[1]) > 16)
		return err("adapter name too long (max 16)");

	sprintf(path_ca, "/dev/dvb/%s/ca0", argv[1]);
	sprintf(path_sec, "/dev/dvb/%s/sec0", argv[1]);

	buf_in = malloc(BUF_SIZE);
	if (buf_in == NULL)
		return err("malloc buf_in");

	/* open devs */

	fd_ca = open(path_ca, O_RDWR);
	if (fd_ca == -1)
		return err("open path_ca");

	fd_sec = open(path_sec, O_RDWR);
	if (fd_sec == -1)
		return err("open path_sec");

	/* start work */

	if (pthread_create(&read_thread, NULL, &read_thread_main, NULL) != 0)
		return err("read_thread start failed.");
	pthread_detach(read_thread);

	/* CA reset loop */

	while (1) {
		sleep(3);

		printf("\nCA reset\n\n");
		ioctl(fd_ca, CA_RESET);
	}
}

Best regards,
Martin Vidovic
