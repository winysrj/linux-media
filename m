Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40262 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbcD0MAz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 08:00:55 -0400
Date: Wed, 27 Apr 2016 09:00:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH] tw686x: use a formula instead of two tables for div
Message-ID: <20160427090049.6add3527@recife.lan>
In-Reply-To: <8344040026ad0985c3c3981e8ec4251fd563258f.1461754812.git.mchehab@osg.samsung.com>
References: <20160427074055.091a90c8@recife.lan>
	<8344040026ad0985c3c3981e8ec4251fd563258f.1461754812.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hmm....

Em Wed, 27 Apr 2016 08:01:19 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Instead of using two tables to estimate the temporal decimation
> factor, use a formula. This allows to get the closest fps, with
> sounds better than the current tables.
> 
> Compile-tested only.

Please discard this patch. It is wrong.

I found the datasheet for this device at:
	http://www.starterkit.ru/html/doc/tw6869-ds.pdf

Based on what it is said on page 50, it seems that it doesn't use a
decimation filter, but, instead, it just discards some fields in
a way that the average fps will be reduced.

So, the actual frame rate is given by the number of enabled bits
that are written to VIDEO_FIELD_CTRL[vc->ch] and are at the
valid bitmask range, e. g:

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

This was done by using the enclosed program.

---

#include <stdio.h>

static const unsigned int map[15] = {
                0x00000000, 0x00000001, 0x00004001, 0x00104001, 0x00404041,
               	0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
                0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
};

unsigned int count_bits(unsigned int bits, unsigned int max)
{
	unsigned int i, c= 0;

	for (i = 0; i < max; i++)
		if ((1 << i) & bits)
			c++;

	return c;
}

void calc_map(unsigned int i)
{
	unsigned int m, fps_30, fps_25;

	m = map[i] << 1;
	m |= m << 1;

	fps_30 = count_bits(m, 30);
	fps_25 = count_bits(m, 25);

	if (m)
		m |= 1 << 31;
	else {
		fps_30 = 30;
		fps_25 = 25;
	}

	printf("index %2i, map = 0x%08x, %d fps (60Hz), %d fps (50Hz)%s\n",
		i, m, fps_30, fps_25,
		i == 0 ? ", output all fields" : ""
		);
}

int main(void)
{
	unsigned int i;

	printf ("\nmap:\n");
	for (i = 0; i < 15; i++)
		calc_map(i);

	return 0;
}
