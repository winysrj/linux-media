Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46061 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJRRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 13:17:45 -0400
Received: by bwz19 with SMTP id 19so252360bwz.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 10:17:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA92DF6.80107@iki.fi>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
	 <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi>
	 <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi>
	 <4AA911B6.2040301@iki.fi>
	 <829197380909100826i3e2f8315yd6a0258f38a6c7b9@mail.gmail.com>
	 <4AA92160.5080200@iki.fi>
	 <829197380909100912xdb34da0s55587f6fe9c0f1d5@mail.gmail.com>
	 <4AA92DF6.80107@iki.fi>
Date: Thu, 10 Sep 2009 13:17:46 -0400
Message-ID: <829197380909101017w17645c56te9fe829b59812800@mail.gmail.com>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 12:48 PM, Antti Palosaari<crope@iki.fi> wrote:
> Yes thats just what I tried to say for. Look my previous thread where all
> currently sizes are listed. We need to define suitable values that are used.
> For example USB2.0 DVB-C, DVB-T, ATSC and same values for USB1.1 too. And
> stream size can vary much depending used transmission parameters too but I
> think such kind resolution logic is not needed.
>
> Currently there is almost everything between 512 to 65k used for DVB-T that
> makes huge difference to load device causing.
>
> Does anyone know if there is some table which says what are good USB
> transmission parameters for each bandwidth needed?

The problem is that there cannot be any single set of rules that apply
to all devices.  For each chip, the rules are different and either
need to be reverse engineered by the maintainer or someone has to
refer to the datasheet if available.

It comes as no surprise that there is a huge variation on the URB
sizes chosen, and there is almost certainly an opportunity for
improvement on most bridges.  I suspect the logic applied by most of
the people who wrote the bridge drivers was to find the first value
that "works" and then not do any subsequent tuning/optimization.  Like
the situation with power management or tuning time, this just doesn't
seem to have been a priority.  And given how few developers we have
actually fixing bugs, adding support for new boards, and writing new
drivers, I can hardly blame them.

Unfortunately, with limited resources, we have to pick our battles -
which is more important:  having a slightly more optimal allocation
that produces fewer wakeups?  Or getting new product XYZ to work and
fixing bugs that are highly visible to end-users?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
