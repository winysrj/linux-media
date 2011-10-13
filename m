Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:38512 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1JMXNM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 19:13:12 -0400
Received: from [192.168.1.13] (c-83-233-163-209.cust.bredband2.com [83.233.163.209])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPSA id EB67D110B15
	for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 01:06:30 +0200 (CEST)
Message-ID: <4E976EF6.1030101@southpole.se>
Date: Fri, 14 Oct 2011 01:06:30 +0200
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: PCTV 520e on Linux
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com>	<CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com>	<4E970CA7.8020807@iki.fi>	<CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com>	<4E970F7A.5010304@iki.fi> <CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com>
In-Reply-To: <CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/13/2011 07:48 PM, Devin Heitmueller wrote:
> On Thu, Oct 13, 2011 at 12:19 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> You were close:  em2884, drx-k, xc5000, and for analog it uses the
>>> afv4910b.
>> Then it should be peace of cake at least for digital side.
> I don't think we've ever done xc5000 on an em28xx before, so it's
> entirely possible that the xc5000 clock stretching will expose bugs in
> the em28xx i2c implementation (it uncovered bugs in essentially every
> other bridge driver I did work on).
>
> That, and we don't know how much is hard-coded into the drx-k driver
> making it specific to the couple of device it's currently being used
> with.
>
> But yeah, it shouldn't be rocket science.  I added support for the
> board in my OSX driver and it only took me a couple of hours.
>
> Devin
>

Eddi De Pieri has patches for the HVR-930C that works somewhat. The
hardware in that stick is the same.

MvH
Benjamin Larsson
