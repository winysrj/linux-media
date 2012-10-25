Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39016 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab2JYNYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 09:24:49 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1553882oag.19
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 06:24:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120929132032.7ce66793@hpe.lwn.net>
References: <1348760305-7481-1-git-send-email-javier.martin@vista-silicon.com>
	<20120929132032.7ce66793@hpe.lwn.net>
Date: Thu, 25 Oct 2012 15:24:49 +0200
Message-ID: <CACKLOr39FO2rsZxT==aaXEiSJ=dq6MQWMyVb7HSvK=EXqejP=A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] media: ov7670: driver cleanup and support for ov7674.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, rusty@rustcorp.com.au, dsd@laptop.org,
	mchehab@infradead.org, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
do you have any problems with this series?

Regards.

On 29 September 2012 21:20, Jonathan Corbet <corbet@lwn.net> wrote:
> On Thu, 27 Sep 2012 17:38:20 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> The following series includes all the changes discussed in [1] that
>> don't affect either bridge drivers that use ov7670 or soc-camera framework
>> For this reason they are considered non controversial and sent separately.
>> At least 1 more series will follow in order to implement all features
>> described in [1].
>
> I'd have preferred to avoid the unrelated white space changes in #1,
> but so be it; you can put my Acked-by on the whole set.
>
> Thanks,
>
> jon



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
