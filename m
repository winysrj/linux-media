Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34032 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab2JYN1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 09:27:09 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1556151oag.19
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 06:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120929132556.22c48312@hpe.lwn.net>
References: <1348831603-18007-1-git-send-email-javier.martin@vista-silicon.com>
	<20120929132556.22c48312@hpe.lwn.net>
Date: Thu, 25 Oct 2012 15:27:08 +0200
Message-ID: <CACKLOr0DQZ9q0yN7NEShAtEMaXf50HgWwaq2s1c84yAj7HShSw@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ov7670: migrate this sensor and its users to ctrl framework.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, rusty@rustcorp.com.au, dsd@laptop.org,
	mchehab@infradead.org, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Jon,
any more issues related with this series?

Regards.

On 29 September 2012 21:25, Jonathan Corbet <corbet@lwn.net> wrote:
> On Fri, 28 Sep 2012 13:26:39 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> The following series migrate ov7670 sensor and current users to ctrl framework
>> as  discussed in [1]. This has been tested against mx2_camera soc-camera bridge,
>> so tests or acks will be required from people using cam-core and via-camera out
>> there.
>
> Looking over the code, I can't really find much to get grumpy about.
> Certainly I like how it removes more code than it adds.  I'm not really
> up on the control framework, though.  What's really needed is to see
> this code actually work on the relevant systems.  I will *try* to do
> that testing, but it's going to take a little while; I don't think I
> can do it by the 3.7 merge window.  Mauro willing, perhaps it can go in
> this time around anyway with the idea that we can sort out any little
> difficulties after -rc1.
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
