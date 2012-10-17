Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37840 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2JQQC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 12:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1210171039410.7402@axis700.grange>
References: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
	<Pine.LNX.4.64.1210171039410.7402@axis700.grange>
Date: Thu, 18 Oct 2012 00:02:24 +0800
Message-ID: <CACVXFVO-h15jrcGbHe6v=wgTr3X3gQnB1Am4x376Mac=vEj3_w@mail.gmail.com>
Subject: Re: [Q] reprobe deferred-probing drivers
From: Ming Lei <tom.leiming@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2012 at 4:43 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 17 Oct 2012, Guennadi Liakhovetski wrote:
>
>> Hi
>>
>> I've got a situation, for which I currently don't have a (good) solution.
>
> Ok, right, would it be acceptable to just do something like
>
>                 if (dev->parent)
>                         device_lock(dev->parent);
>                 device_release_driver(dev);
>                 device_attach(dev);

The above should be OK for your purpose, and looks some other
deferred-probe devices may need this handling too.

But I am wondering how you could get the pointer of device A for
releasing driver in device B's remove()?

Thanks,
-- 
Ming Lei
