Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:57440 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaE1Ppp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 11:45:45 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6A00HMTJS8VV90@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 May 2014 11:45:44 -0400 (EDT)
Date: Wed, 28 May 2014 12:45:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Michael Durkin <kc7noa@gmail.com>
Cc: Steven Toth <stoth@kernellabs.com>, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: am i in the right list?
Message-id: <20140528124538.74282a22.m.chehab@samsung.com>
In-reply-to: <CAC8M0EuVpN9NLg50H9+h0qX1h8SFM4UZM3otPjmsDUT9+Zt9=Q@mail.gmail.com>
References: <CAC8M0EtVTh+EmDaJa-Xmtm17x8VK6ozzw2A56Et_aj_m8ZFdpw@mail.gmail.com>
 <537CF2C4.6030302@iki.fi>
 <CAC8M0EsCjtc2+uPEQ=n36h_w4OEjoZOaHViAQgF_0MshgF2TJw@mail.gmail.com>
 <CALzAhNU50EFaZ83_+=4GYHN-rBdHPEMU3zufbqXroCJSJctmTw@mail.gmail.com>
 <CAC8M0Eu7AyMJxyo-knwXdeJEy_UAYMs=ufE+oDK-kwHWrqvPQg@mail.gmail.com>
 <CALzAhNX-m83z_odrt3=BiX-1zxQsH=N7H72DWSfEPtUqxtXYyA@mail.gmail.com>
 <CAC8M0EuVpN9NLg50H9+h0qX1h8SFM4UZM3otPjmsDUT9+Zt9=Q@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 May 2014 08:09:55 -0700
Michael Durkin <kc7noa@gmail.com> escreveu:

> Then i guess it will not be supported any time soon .... its been for
> sale for almost a year.
> Im a stay at home dad, not a developer. The chance of me paying some
> one to write code is next to nill ....
> 
> Thank you for the response  ....

Back to your original question, I'm not sure if this is the right ML...
the device you pointed is a VGA adapter? If so, this is not the right
ML. This one is for webcams, TV, capture devices and video out devices.

AFAICT, VGA adapters are handled by Xorg people.

> 
> On Wed, May 28, 2014 at 7:29 AM, Steven Toth <stoth@kernellabs.com> wrote:
> > On Tue, May 27, 2014 at 8:18 PM, Michael Durkin <kc7noa@gmail.com> wrote:
> >> what's the process tree like when its looked at?
> >>
> >> 1d5c:2000
> >>
> >> On Thu, May 22, 2014 at 8:44 AM, Steven Toth <stoth@kernellabs.com> wrote:
> >>>> Should i email Hans Verkuil or would he see this already ?
> >>>> Fresco Logic FL2000 USB to VGA adapter
> >>>
> >>> He would have seen this already.
> >
> > I'm not sure I understand your question but let me take a shot at what
> > I think you mean. I think you mean, how does a developer someone go
> > about creating a driver for a new product?
> >
> > 1. They announce their intensions on the mailing-list (here), just to
> > check that no other developer is actively working the same driver.
> > This isn't mandatory, but can often avoid cases where multiple people
> > are working on the same end-goal.
> >
> > 2. Wait a week, anyone interested will likely comment very quickly, if
> > they are already working on something. If you get little or no
> > feedback then nobody is working in that area.
> >
> > 3. Assuming nobody is working on it (as in your case), go ahead and
> > start development - or hire someone to engineer the driver on your
> > behalf.
> >
> > :)
> >
> > --
> > Steven Toth - Kernel Labs
> > http://www.kernellabs.com
> > +1.646.355.8490
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
