Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37975 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab1BNPLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 10:11:07 -0500
MIME-Version: 1.0
In-Reply-To: <201102141450.31975.laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<201102141419.24953.laurent.pinchart@ideasonboard.com>
	<20110214134116.GG2549@legolas.emea.dhcp.ti.com>
	<201102141450.31975.laurent.pinchart@ideasonboard.com>
Date: Mon, 14 Feb 2011 17:11:05 +0200
Message-ID: <AANLkTin-vJuDUWeMOpQktnkHgTTXGxqm4+se1p90y1YT@mail.gmail.com>
Subject: Re: [PATCH v6 04/10] omap2: Fix camera resources for multiomap
From: David Cohen <dacohen@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: balbi@ti.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 14, 2011 at 3:50 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Felipe,

Hello,

>
> On Monday 14 February 2011 14:41:16 Felipe Balbi wrote:
>> On Mon, Feb 14, 2011 at 02:19:24PM +0100, Laurent Pinchart wrote:
>> > On Monday 14 February 2011 13:35:59 Felipe Balbi wrote:
>> > > On Mon, Feb 14, 2011 at 01:21:31PM +0100, Laurent Pinchart wrote:
>> > > > diff --git a/arch/arm/mach-omap2/devices.c
>> > > > b/arch/arm/mach-omap2/devices.c index 4cf48ea..5d844bd 100644
>> > > > --- a/arch/arm/mach-omap2/devices.c
>> > > > +++ b/arch/arm/mach-omap2/devices.c
>> > > > @@ -38,7 +38,7 @@
>> > > >
>> > > >  #if defined(CONFIG_VIDEO_OMAP2) ||
>> > > >  defined(CONFIG_VIDEO_OMAP2_MODULE)
>> > > >
>> > > > -static struct resource cam_resources[] = {
>> > > > +static struct resource omap2cam_resources[] = {
>> > >
>> > > should this be __initdata ??
>> >
>> > The resources will be used when the OMAP3 ISP module is loaded. Won't
>> > they be discared if marked as __initdata ?
>>
>> I believe driver core makes a copy of those, no ? not sure.
>
> Not that I know of, but I may be wrong.

I don't think omap2cam_resources would be used at all.
AFAIK, it belongs to omap2xxcam, isn't it? :)

Br,

David
