Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62781 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab0JaLvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 07:51:03 -0400
Received: by iwn10 with SMTP id 10so5814860iwn.19
        for <linux-media@vger.kernel.org>; Sun, 31 Oct 2010 04:51:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CCB1443.9080509@stanford.edu>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
	<201010290139.10204.laurent.pinchart@ideasonboard.com>
	<AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>
	<AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>
	<AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>
	<AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
	<4CCB1443.9080509@stanford.edu>
Date: Sun, 31 Oct 2010 12:51:02 +0100
Message-ID: <AANLkTimY+sWWxF9+9P5uq8nDeSPdq0jRegtkfvEWRj-+@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Eino-Ville Talvala <talvala@stanford.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Eino-Ville,

>
> Most of the ISP can't handle more than 10-bit input - unless you're
> streaming raw sensor data straight to memory, you'll have to use the bridge
> lane shifter to decimate the input.
> In the new framework, I don't know how that's done, unfortunately.

Thank you for pointing me to it. Now I read about it in the technical
reference manual too
(http://focus.ti.com/lit/ug/spruf98k/spruf98k.pdf).
At page 1392 it mentions the possibility to reduce the precision from
12- to 10-bit. It turns out Laurent already sent me the right
configuration in a side note of a former post of me. On page 1574 I
found another related register: CCDC_FMTCFG. Here you can select which
10 of the 12 bits you want to keep.
I looked up the code-flow for the isp-framework and post it here for reference:

static struct isp_v4l2_subdevs_group bastix_camera_subdevs[] = {
        {
                .subdevs = bastix_camera_mt9p031,
                .interface = ISP_INTERFACE_PARALLEL,
                .bus = { .parallel = {
                       .data_lane_shift        = 1,
        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                       .clk_pol                = 1,
                       .bridge                 = ISPCTRL_PAR_BRIDGE_DISABLE,
                } },
        },
        { NULL, 0, },
};
static struct isp_platform_data bastix_isp_platform_data = {
        .subdevs = bastix_camera_subdevs,
};
...
omap3isp_device.dev.platform_data = &bastix_isp_platform_data;
-----------------------
The config is handled in isp.c here:
void isp_configure_bridge(struct isp_device *isp, enum ccdc_input_entity input,
                          const struct isp_parallel_platform_data *pdata)
{
...
        switch (input) {
        case CCDC_INPUT_PARALLEL:
                ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
                ispctrl_val |= pdata->data_lane_shift <<
ISPCTRL_SHIFT_SHIFT;   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
                ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
                ispctrl_val |= pdata->bridge << ISPCTRL_PAR_BRIDGE_SHIFT;
                break;

...
}

> Also, technically, the mt9p031 output colorspace is not sRGB, although I'm
> not sure how close it is. It's its own sensor-specific space, determined by
> the color filters on it, and you'll want to calibrate for it at some point.

The output format of the sensor is

R   Gr
Gb B

The same colorspace is given as example in spruf98k on page 1409.
There I am still confused about the sematic of 1 pixel. Is it the
quadruple of the bayer values or each component? Or does it depend on
the context? Does the the sensor send 5MP data to the isp or 5MPx4
bayer values? Does the 12-bit width belong to each bayer value? In the
sensor you read from right to left, I don't know if the ISP doc means
reading left to right. And so on and so on...

> Good luck,

As you can see I need and appreciate it :)

About the freezing ioctl. I discovered that I have a clocking issue. I
will solve it monday and see if it works better and had an impact on
the isp-driver.


> Eino-Ville Talvala
> Stanford University
>

cheers,

 Bastian
