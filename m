Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbZKSIBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 03:01:22 -0500
Message-ID: <4B04FCF6.2060505@redhat.com>
Date: Thu, 19 Nov 2009 09:08:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFC, PATCH] gspca: implement vidioc_enum_frameintervals
References: <20091117114147.09889427.ospite@studenti.unina.it>
In-Reply-To: <20091117114147.09889427.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/17/2009 11:41 AM, Antonio Ospite wrote:
> Hi,
>
> gspca does not implement vidioc_enum_frameintervals yet, so even if a
> camera can support multiple frame rates (or frame intervals) there is
> still no way to enumerate them from userspace.
>
> The following is just a quick and dirty implementation to show the
> problem and to have something to base the discussion on. In the patch
> there is also a working example of use with the ov534 subdriver.
>
> Someone with a better knowledge of gspca and v4l internals can suggest
> better solutions.
>


Does the ov534 driver actually support selecting a framerate from the
list this patch adds, and does it then honor the selection ?

In my experience framerates with webcams are varying all the time, as
the lighting conditions change and the cam needs to change its exposure
setting to match, resulting in changed framerates.

So to me this does not seem very useful for webcams.

Regards,

Hans
