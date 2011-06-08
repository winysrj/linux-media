Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55578 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1FHMmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 08:42:19 -0400
Received: by eyx24 with SMTP id 24so156904eyx.19
        for <linux-media@vger.kernel.org>; Wed, 08 Jun 2011 05:42:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106081439030.24274@axis700.grange>
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com>
	<201106081357.51578.laurent.pinchart@ideasonboard.com>
	<4CF44DCA-BCCA-4AA6-AE14-DAADE66767B4@beagleboard.org>
	<Pine.LNX.4.64.1106081439030.24274@axis700.grange>
Date: Wed, 8 Jun 2011 14:42:17 +0200
Message-ID: <BANLkTinw6GoHgQYqJexbD-4=qitP6j0hDg@mail.gmail.com>
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron)
 mt9p031 sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Koen Kooi <koen@beagleboard.org>, beagleboard@googlegroups.com,
	linux-media@vger.kernel.org, carlighting@yahoo.co.nz,
	mch_kot@yahoo.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 8 June 2011 14:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Wed, 8 Jun 2011, Koen Kooi wrote:
>
>>
>> Op 8 jun 2011, om 13:57 heeft Laurent Pinchart het volgende geschreven:
>>
>> > Hi Javier,
>> >
>> > I'm testing your patch on a 2.6.39 kernel. Here's what I get when loading the
>> > omap3-isp module.
>> >
>> > root@arago:~# modprobe omap3-isp
>> > [  159.523681] omap3isp omap3isp: Revision 15.0 found
>> > [  159.528991] omap-iommu omap-iommu.0: isp: version 1.1
>> > [  159.875701] omap_i2c omap_i2c.2: Arbitration lost
>> > [  159.881622] mt9p031 2-0048: Failed to reset the camera
>> > [  159.887054] omap3isp omap3isp: Failed to power on: -5
>> > [  159.892425] mt9p031 2-0048: Failed to power on device: -5
>> > [  159.898956] isp_register_subdev_group: Unable to register subdev mt9p031
>> >
>> > Have you (or anyone else) seen that issue ?
>>
>> I build in both statically to avoid that problem.
>
> I used modules and it worked for me.

Maybe u-boot version Laurent uses does not enable internal pull-up
resistors for i2c2 interface.
You could either use a different u-boot version or attach external
pull-up resistors to that interface.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
