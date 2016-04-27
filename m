Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcD0WuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 18:50:07 -0400
Date: Wed, 27 Apr 2016 19:50:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tw686x: use a formula instead of two tables for div
Message-ID: <20160427195001.5b96bfb9@recife.lan>
In-Reply-To: <20160427090049.6add3527@recife.lan>
References: <20160427074055.091a90c8@recife.lan>
	<8344040026ad0985c3c3981e8ec4251fd563258f.1461754812.git.mchehab@osg.samsung.com>
	<20160427090049.6add3527@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Apr 2016 09:00:49 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hmm....
> 
> Em Wed, 27 Apr 2016 08:01:19 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
> > Instead of using two tables to estimate the temporal decimation
> > factor, use a formula. This allows to get the closest fps, with
> > sounds better than the current tables.
> > 
> > Compile-tested only.  
> 
> Please discard this patch. It is wrong.
> 
> I found the datasheet for this device at:
> 	http://www.starterkit.ru/html/doc/tw6869-ds.pdf
> 
> Based on what it is said on page 50, it seems that it doesn't use a
> decimation filter, but, instead, it just discards some fields in
> a way that the average fps will be reduced.
> 
> So, the actual frame rate is given by the number of enabled bits
> that are written to VIDEO_FIELD_CTRL[vc->ch]

Ok, I think I got this right this time. See the enclosed code.

It produces the fps register map, with each fps associated to
both 60Hz and 50Hz standard, plus it replaces the tables by a
calculus.

If my code is right, there are some values on the current tables
that are wrong.

See below. I'll submit an updated patch soon.

---
Program results:

FPS map:
	index  0, map = 0x00000000, 30 fps (60Hz), 25 fps (50Hz), output all fields
	index  1, map = 0x80000006, 2 fps (60Hz), 2 fps (50Hz)
	index  2, map = 0x80018006, 4 fps (60Hz), 4 fps (50Hz)
	index  3, map = 0x80618006, 6 fps (60Hz), 6 fps (50Hz)
	index  4, map = 0x81818186, 8 fps (60Hz), 8 fps (50Hz)
	index  5, map = 0x86186186, 10 fps (60Hz), 8 fps (50Hz)
	index  6, map = 0x86619866, 12 fps (60Hz), 10 fps (50Hz)
	index  7, map = 0x86666666, 14 fps (60Hz), 12 fps (50Hz)
	index  8, map = 0x9999999e, 16 fps (60Hz), 14 fps (50Hz)
	index  9, map = 0x99e6799e, 18 fps (60Hz), 16 fps (50Hz)
	index 10, map = 0x9e79e79e, 20 fps (60Hz), 16 fps (50Hz)
	index 11, map = 0x9e7e7e7e, 22 fps (60Hz), 18 fps (50Hz)
	index 12, map = 0x9fe7f9fe, 24 fps (60Hz), 20 fps (50Hz)
	index 13, map = 0x9ffe7ffe, 26 fps (60Hz), 22 fps (50Hz)
	index 14, map = 0x9ffffffe, 28 fps (60Hz), 24 fps (50Hz)

60 Hz
	Requested fps 0, table 0 (30 fps, delta 30), calculus 1 (2 fps, delta 2) DIFFERENT!
	Requested fps 1, table 1 (2 fps, delta 1), calculus 1 (2 fps, delta 1)
	Requested fps 2, table 1 (2 fps, delta 0), calculus 1 (2 fps, delta 0)
	Requested fps 3, table 1 (2 fps, delta -1), calculus 1 (2 fps, delta -1)
	Requested fps 4, table 2 (4 fps, delta 0), calculus 2 (4 fps, delta 0)
	Requested fps 5, table 2 (4 fps, delta -1), calculus 2 (4 fps, delta -1)
	Requested fps 6, table 3 (6 fps, delta 0), calculus 3 (6 fps, delta 0)
	Requested fps 7, table 3 (6 fps, delta -1), calculus 3 (6 fps, delta -1)
	Requested fps 8, table 4 (8 fps, delta 0), calculus 4 (8 fps, delta 0)
	Requested fps 9, table 4 (8 fps, delta -1), calculus 4 (8 fps, delta -1)
	Requested fps 10, table 5 (10 fps, delta 0), calculus 5 (10 fps, delta 0)
	Requested fps 11, table 5 (10 fps, delta -1), calculus 5 (10 fps, delta -1)
	Requested fps 12, table 6 (12 fps, delta 0), calculus 6 (12 fps, delta 0)
	Requested fps 13, table 6 (12 fps, delta -1), calculus 6 (12 fps, delta -1)
	Requested fps 14, table 7 (14 fps, delta 0), calculus 7 (14 fps, delta 0)
	Requested fps 15, table 7 (14 fps, delta -1), calculus 7 (14 fps, delta -1)
	Requested fps 16, table 8 (16 fps, delta 0), calculus 8 (16 fps, delta 0)
	Requested fps 17, table 8 (16 fps, delta -1), calculus 8 (16 fps, delta -1)
	Requested fps 18, table 9 (18 fps, delta 0), calculus 9 (18 fps, delta 0)
	Requested fps 19, table 9 (18 fps, delta -1), calculus 9 (18 fps, delta -1)
	Requested fps 20, table 10 (20 fps, delta 0), calculus 10 (20 fps, delta 0)
	Requested fps 21, table 10 (20 fps, delta -1), calculus 10 (20 fps, delta -1)
	Requested fps 22, table 11 (22 fps, delta 0), calculus 11 (22 fps, delta 0)
	Requested fps 23, table 11 (22 fps, delta -1), calculus 11 (22 fps, delta -1)
	Requested fps 24, table 12 (24 fps, delta 0), calculus 12 (24 fps, delta 0)
	Requested fps 25, table 12 (24 fps, delta -1), calculus 12 (24 fps, delta -1)
	Requested fps 26, table 13 (26 fps, delta 0), calculus 13 (26 fps, delta 0)
	Requested fps 27, table 13 (26 fps, delta -1), calculus 13 (26 fps, delta -1)
	Requested fps 28, table 14 (28 fps, delta 0), calculus 14 (28 fps, delta 0)
	Requested fps 29, table 0 (30 fps, delta 1), calculus 14 (28 fps, delta -1) DIFFERENT!
	Requested fps 30, table 0 (30 fps, delta 0), calculus 0 (30 fps, delta 0)

50 Hz
	Requested fps 0, table 0 (25 fps, delta 25), calculus 1 (2 fps, delta 2) DIFFERENT!
	Requested fps 1, table 1 (2 fps, delta 1), calculus 1 (2 fps, delta 1)
	Requested fps 2, table 1 (2 fps, delta 0), calculus 1 (2 fps, delta 0)
	Requested fps 3, table 2 (4 fps, delta 1), calculus 2 (4 fps, delta 1)
	Requested fps 4, table 3 (6 fps, delta 2), calculus 2 (4 fps, delta 0) DIFFERENT!
	Requested fps 5, table 3 (6 fps, delta 1), calculus 3 (6 fps, delta 1)
	Requested fps 6, table 4 (8 fps, delta 2), calculus 3 (6 fps, delta 0) DIFFERENT!
	Requested fps 7, table 4 (8 fps, delta 1), calculus 4 (8 fps, delta 1)
	Requested fps 8, table 5 (8 fps, delta 0), calculus 5 (8 fps, delta 0)
	Requested fps 9, table 5 (8 fps, delta -1), calculus 5 (8 fps, delta -1)
	Requested fps 10, table 6 (10 fps, delta 0), calculus 6 (10 fps, delta 0)
	Requested fps 11, table 7 (12 fps, delta 1), calculus 7 (12 fps, delta 1)
	Requested fps 12, table 7 (12 fps, delta 0), calculus 7 (12 fps, delta 0)
	Requested fps 13, table 8 (14 fps, delta 1), calculus 8 (14 fps, delta 1)
	Requested fps 14, table 8 (14 fps, delta 0), calculus 8 (14 fps, delta 0)
	Requested fps 15, table 9 (16 fps, delta 1), calculus 9 (16 fps, delta 1)
	Requested fps 16, table 10 (16 fps, delta 0), calculus 10 (16 fps, delta 0)
	Requested fps 17, table 10 (16 fps, delta -1), calculus 10 (16 fps, delta -1)
	Requested fps 18, table 11 (18 fps, delta 0), calculus 11 (18 fps, delta 0)
	Requested fps 19, table 11 (18 fps, delta -1), calculus 11 (18 fps, delta -1)
	Requested fps 20, table 12 (20 fps, delta 0), calculus 12 (20 fps, delta 0)
	Requested fps 21, table 13 (22 fps, delta 1), calculus 13 (22 fps, delta 1)
	Requested fps 22, table 13 (22 fps, delta 0), calculus 13 (22 fps, delta 0)
	Requested fps 23, table 14 (24 fps, delta 1), calculus 14 (24 fps, delta 1)
	Requested fps 24, table 14 (24 fps, delta 0), calculus 14 (24 fps, delta 0)
	Requested fps 25, table 0 (25 fps, delta 0), calculus 0 (25 fps, delta 0)

---

Program:

#include <stdio.h>

static const unsigned int std_625_50[26] = {
                0, 1, 1, 2,  3,  3,  4,  4,  5,  5,  6,  7,  7,
                   8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 0
};

static const unsigned int std_525_60[31] = {
                0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
                   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
};

static const unsigned int map[15] = {
                0x00000000, 0x00000001, 0x00004001, 0x00104001, 0x00404041,
               	0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
                0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
};

unsigned int real_rate(unsigned int index, unsigned int max)
{
	unsigned int i, bits, c = 0;

	if (!index)
		return max;

	bits = map[index] << 1;
	bits |= bits << 1;

	for (i = 0; i < max; i++)
		if ((1 << i) & bits)
			c++;

	return c;
}

void calc_map(unsigned int i)
{
	unsigned int m, fps_30, fps_25;

	fps_30 = real_rate(i, 30);
	fps_25 = real_rate(i, 25);

	m = map[i] << 1;
	m |= m << 1;

	if (m)
		m |= 1 << 31;
	else {
		fps_30 = 30;
		fps_25 = 25;
	}

	printf("\tindex %2i, map = 0x%08x, %d fps (60Hz), %d fps (50Hz)%s\n",
		i, m, fps_30, fps_25,
		i == 0 ? ", output all fields" : ""
		);
}

unsigned int get_index(unsigned int fps, unsigned int max_fps)
{
	unsigned int idx, real_fps;
	int delta;

	if (real_fps == max_fps)
		return 0;

	if (fps < 2)
		return 1;

	/* First guess */
	idx = (12 + 15 * fps) / max_fps;

	/* Check if the difference is bigger than abs(1) and adjust */
	real_fps = real_rate(idx, max_fps);
	delta = real_fps - fps;
	if (delta < -1)
		idx++;
	else if (delta > 1)
		idx--;

	if (idx >= 15)
		return 0;

	return idx;
}


void calc_fps(unsigned int max_fps)
{
	unsigned int i1, i2, fps, adjust;
	unsigned int fps1, fps2;

	for (fps = 0; fps <= max_fps; fps++) {
		if (max_fps == 30)
			i1 = std_525_60[fps];
		else
			i1 = std_625_50[fps];

		i2 = get_index(fps, max_fps);

		fps1 = real_rate(i1, max_fps);
		fps2 = real_rate(i2, max_fps);

		printf("\tRequested fps %d, table %d (%d fps, delta %d), calculus %d (%d fps, delta %d)%s\n",
			fps,
			i1, fps1, fps1 - fps,
			i2, fps2, fps2 - fps,
			(i1 != i2) ? " DIFFERENT!": "");
	}
}

int main(void)
{
	unsigned int i;

	printf ("FPS map:\n");
	for (i = 0; i < 15; i++)
		calc_map(i);

	printf ("\n60 Hz\n");
	calc_fps(30);

	printf ("\n50 Hz\n");
	calc_fps(25);

	return 0;
}
