Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:58741 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbeHVPyq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 11:54:46 -0400
Received: from [10.10.16.42] (port=62184 helo=ICSMA001.intenta.de)
        by mail.intenta.de with esmtps (TLSv1.2:AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <Helmut.Grohne@intenta.de>)
        id 1fsSBl-0005eb-2o
        for linux-media@vger.kernel.org; Wed, 22 Aug 2018 14:24:41 +0200
Date: Wed, 22 Aug 2018 14:24:42 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: <linux-media@vger.kernel.org>
Subject: V4L2 analogue gain contol
Message-ID: <20180822122441.7zxj4e5dczdzmo5m@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been looking at various image sensor drivers to see how they expose
gains, in particular analogue ones. What I found in 4.18 looks like a
mess to me.

In particular, my interest is about separation of analogue vs digital
gain and an understanding of what effect a change in gain has on the
brightness of an image. The latter is characterized in the following
table in the "linear" column.

driver  | CID | register name               | min | max  | def | linear | comments
--------+-----+-----------------------------+-----+------+-----+--------+---------
adv7343 | G   | ADV7343_DAC2_OUTPUT_LEVEL   | -64 | 64   | 0   |        |
adv7393 | G   | ADV7393_DAC123_OUTPUT_LEVEL | -64 | 64   | 0   |        |
imx258  | A   | IMX258_REG_ANALOG_GAIN      | 0   | 8191 | 0   |        |
imx274  | G   | multiple                    |     |      |     | yes    | [1]
mt9m032 | G   | MT9M032_GAIN_ALL            | 0   | 127  | 64  | no     | [2]
mt9m111 | G   | GLOBAL_GAIN                 | 0   | 252  | 32  | no     | [3]
mt9p031 | G   | MT9P031_GLOBAL_GAIN         | 8   | 1024 | 8   | no     | [4]
mt9v011 | G   | multiple                    | 0   | 4063 | 32  |        |
mt9v032 | G   | MT9V032_ANALOG_GAIN         | 16  | 64   | 16  | no     | [5]
ov13858 | A   | OV13858_REG_ANALOG_GAIN     | 0   | 8191 | 128 |        |
ov2685  | A   | OV2685_REG_GAIN             | 0   | 2047 | 54  |        |
ov5640  | G   | OV5640_REG_AEC_PK_REAL_GAIN | 0   | 1023 | 0   |        |
ov5670  | A   | OV5670_REG_ANALOG_GAIN      | 0   | 8191 | 128 |        |
ov5695  | A   | OV5695_REG_ANALOG_GAIN      | 16  | 248  | 248 |        |
mt9m001 | G   | MT9M001_GLOBAL_GAIN         | 0   | 127  | 64  | no     |
mt9v022 | G   | MT9V022_ANALOG_GAIN         | 0   | 127  | 64  |        |

CID:
  A -> V4L2_CID_ANALOGUE_GAIN
  G -> V4L2_CID_GAIN, no V4L2_CID_ANALOGUE_GAIN present
step: always 1
comments:
[1] controls a product of analogue and digital gain, value scales
    roughly linear
[2] code comments contradict data sheet
[3] it is not clear whether it also controls a digital gain.
[4] controls a combination of analogue and digital gain
[5] analogue only

The documentation (extended-controls.rst) says that the digital gain is
supposed to be a linear fixed-point number with 0x100 meaning factor 1.
The situation for analogue is much less precise.

Typically, the number of analogue gains is much smaller than the number
of digital gains. No driver exposes more than 13 bit for the analogue
gain and half of them use at most 8 bits.

Can we give more structure to the analogue gain as exposed by V4L2?
Ideally, I'd like to query a driver for the possible gain values if
there are few (say < 256) and their factors (which are often given in
data sheets). The nature of gains though is that they are often similar
to floating point numbers (2 ** exp * (1 + mant / precision)), which
makes it difficult to represent them using min/max/step/default.

Would it be reasonable to add a new V4L2_CID_ANALOGUE_GAIN_MENU that
claims linearity and uses fixed-point numbers like
V4L2_CID_DIGITAL_GAIN? There already is the integer menu
V4L2_CID_AUTO_EXPOSURE_BIAS, but it also affects the exposure.

An important application is implementing a custom gain control when the
built-in auto exposure is not applicable.

Helmut
