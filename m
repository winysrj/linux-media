Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbZKHRLQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 12:11:16 -0500
Message-ID: <4AF6FCFD.6000200@redhat.com>
Date: Sun, 08 Nov 2009 18:16:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l problem decoding frames from pac7302
References: <4AF6C7D1.6040000@freemail.hu>
In-Reply-To: <4AF6C7D1.6040000@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/08/2009 02:29 PM, Németh Márton wrote:
> Hi,
>
> I have some problem that libv4l cannot decode all image coming from the
> Labtec Webcam 2200. There are some cases when no image at all can be decoded.
> This case can be reproduced always for example by setting the camera to test
> mode to produce a color test bar. The raw data arrives from the driver (41472
> bytes, see attached) and v4lconvert_convert() returns -1 and the errno is set
> to EAGAIN. In this case the v4lconvert_get_error_message() reports the
> following error message:
>
> v4l-convert: error decompressing JPEG: Pixart JPEG error: invalid MCU marker: 0xff
>

See:

libv4lconvert/tinyjpeg.c, lines 1611-1620 for some info on the magical byte
pixart puts between Huffman data blocks.

The 0xff value probably is normal for the test mode, so I would start with trying
to change the MCU test to also except 0xff as a valid MCU marker

Regards,

hans


> Steps to reproduce:
> 1. get 13327:19c0469c02c3 from http://linuxtv.org/hg/v4l-dvb/
> 2. apply the patch http://www.spinics.net/lists/linux-media/msg11841.html
> 3. apply the patch http://www.spinics.net/lists/linux-media/msg11842.html
> 4. compile and install the new driver
> 5. plug Labtec Webcam 2200
> 6. start capturing
> 7. execute "v4l2-dbg --set-register=0x72 9", this will switch on the color
>     test card of the webcam.
>
> Current result: v4lconvert_convert() always return -1 and errno is EAGAIN until
> the olor test card is not switched off with "v4l2-dbg --set-register=0x72 0".
>
> How would you start to fix this?
>
> Regards,
>
> 	Márton Németh
>
