Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:34180 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab1EKQRD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:17:03 -0400
Date: Wed, 11 May 2011 15:12:37 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"S-bastien RAILLARD" <sr@coexsi.fr>,
	Oliver Endriss <o.endriss@gmx.de>
Mime-Version: 1.0
Message-ID: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
Content-Type: multipart/mixed;
	boundary="----NetAddressPart-00--=_kNLl1856S046f972b92"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.

------NetAddressPart-00--=_kNLl1856S046f972b92
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Ralph Metzler <rjkm@metzlerbros.de>
> Issa Gorissen writes:
>  > Could you please take a look at the cxd2099 issues ?
>  > =

>  > I have attached a version with my changes. I have tested a lot of
>  > different settings with the help of the chip datasheet.
>  > =

>  > Scrambled programs are not handled correctly. I don't know if it is =
the
>  > TICLK/MCLKI which is too high or something, or the sync detector ? A=
lso,
>  > as we have to set the TOCLK to max of 72MHz, there are way too much =
null
>  > packets added. Is there a way to solve this ?
> =

> I do not have any cxd2099 issues.
> I have a simple test program which includes a 32bit counter as payload =

> and can pump data through the CI with full speed and have no packet
> loss. I only tested decoding with an ORF stream and an Alphacrypt CAM
> but also had no problems with this.
> =

> Please take care not to write data faster than it is read. Starting two=

> dds will not guarantee this. To be certain you could write a small
> program which never writes more packets than input buffer size minus
> the number of read packets (and minus the stuffing null packets on ngen=
e).
> =

> Before blaming packet loss on the CI data path also please make
> certain that you have no buffer overflows in the input part of =

> the sec device.
> In the ngene driver you can e.g. add a printk in tsin_exchange():
> =

> if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
> ...
> } else
>     printk ("buffer overflow !!!!\n");
> =

> =

> Regards,
> Ralph


Ralph,

Please find my testing tool for the decryption attached. The idea is to w=
rite
5 packets and read them back from the CAM.

My input is a raw ts captured with a gnutv I modified with a demux filter=
 of
0x2000. Gnutv outputs at dvr and dvbloop reads from it, process via sec0 =
and
writes output to a file.

The channel I selected has been decrypted. Only problem is I have artifac=
ts in
the image and the sound.

Do you have any idea of what I should improve from my test tool to fix th=
at
issue ?


Thx,
--
Issa


------NetAddressPart-00--=_kNLl1856S046f972b92
Content-Type: text/x-csrc; name="dvbloop.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline; filename="dvbloop.c"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <time.h>

static void signal_handler(int _signal);
static int quit_app =3D 0;

int main(int argc, char *argv[])
{
	signal(SIGINT, signal_handler);

	if (argc <=3D 3)
		exit(1);	=


	int in_fd =3D open(argv[1], O_RDONLY);
	int out_fd =3D open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_I=
WUSR);
	int tsi_fd =3D open(argv[3], O_RDWR);

	int rlen =3D 0;
	int wlen =3D 0;
	int rtsilen =3D 0;
	int wtsilen =3D 0;

	int BUFFY =3D 188 * 5;
	unsigned char buf[BUFFY];
	struct timespec sl[1];
	sl[0].tv_nsec =3D 250000;
	=

	while (!quit_app)
	{
		// read from input (DVR or other)
		rlen =3D 0;
		while (rlen < BUFFY) {
			int i =3D read(in_fd, buf + rlen, BUFFY - rlen);
			if (!i) {
				quit_app =3D 1;
				continue;
			}
			rlen +=3D i;
		}
		=

		// write data to caio device
		wlen =3D write(tsi_fd, buf, rlen);
		if (wlen !=3D rlen)
		{
			perror("Did not write same amount of data from input to caio!!!");
			exit(1);
		}/* else
			printf("written %d bytes in tsi\n", wlen);
	*/

		// read data from caio device - should be decrypted
		// finding sync byte
		do {
			buf[0] =3D 0;
			while (buf[0] !=3D 0x47) {
				rtsilen =3D read(tsi_fd, buf, 1);
			}
			=

			if (buf[0] =3D=3D 0x47) {
				do {
					int i =3D read(tsi_fd, buf + rtsilen, 188 - rtsilen);
					rtsilen +=3D i;
//					printf("reading %d bytes from tsi\n", i);
				} while (rtsilen < 188);

				break;
			}
		} while (1);

//printf("sync byte found: %02x \n", buf[0]);

		wtsilen =3D 0;
		int nulls =3D 0;
		do {
			if (buf[0] =3D=3D 0x47 && buf[1] =3D=3D 0x1F && buf[2] =3D=3D 0xFF) {
				++nulls;
				if (nulls > 100)
					break;

//				printf("null packet ");
				// DVB null packet, discard
			} else {
//			printf("\nfrom tsi out: %x %x %x \n", buf[0], buf[1], buf[2]);
				// write packet to output
				int i =3D write(out_fd, buf, 188);
				if (i < 188) {
					perror("Did not write 188 bytes to output file!!!");
				}
				wtsilen +=3D i;
			}

			if (rlen =3D=3D wtsilen || quit_app)
				break;

			rtsilen =3D 0;
			do {
				rtsilen +=3D read(tsi_fd, buf + rtsilen, 188 - rtsilen);
			} while (rtsilen < 188);
		} while (1);
	}

	close(in_fd);
	close(out_fd);
	close(tsi_fd);

	exit(0);
}


static void signal_handler(int _signal)
{
	if (!quit_app)
	{
		quit_app =3D 1;
	}
}

------NetAddressPart-00--=_kNLl1856S046f972b92--
