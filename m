Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63021 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FVRIb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 13:08:31 -0400
Received: by pvg12 with SMTP id 12so630391pvg.19
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 10:08:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
Date: Wed, 22 Jun 2011 13:08:29 -0400
Message-ID: <BANLkTi=zQNyxv=fp23ju8M0BYHGjE=yaBg@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Michael Krufky <mkrufky@linuxtv.org>
To: HoP <jpetrous@gmail.com>
Cc: linux-media@vger.kernel.org, k@linux.com,
	Ales Jurik <ajurik@smartimp.cz>,
	Honza Petrous <jpetrous@smartimp.cz>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 18, 2011 at 8:10 PM, HoP <jpetrous@gmail.com> wrote:
> Hi,
>
> get inspired by (unfortunately close-source) solution on stb
> Dreambox 800 I have made my own implementation
> of virtual DVB device, based on the same device API.
>
> In conjunction with "Dreamtuner" userland project
> [http://code.google.com/p/dreamtuner/] by Ronald Mieslinger
> user can create virtual DVB device on client side and connect it
> to the server. When connected, user is able to use any Linux DVB API
> compatible application on client side (like VDR, MeTV, MythTV, etc)
> without any need of code modification. As server can be used any
> Linux DVB API compatible device.


I can think of many interesting uses for a solution like this.  It's
great that such a driver exists and that people can use it now to
create interesting do-it-yourself projects, however, I do not believe
this should ever be merged into the kernel.

If this solution were merged into the kernel, there would be no reason
for companies like Hauppauge to ever again contribute any open source
drivers.  Once it's possible to deliver a closed source driver to the
masses, that's what vendors will do -- there will no longer be any
motivation to continue working in open source.

Some may like that idea, but I feel this will destroy the foundation
that we've been building for years.

I repeat, the solution itself has some potential, and I see nothing
wrong with this existing and being available to users in source code
form, but it should never be merged into a kernel to be shipped
directly to end-users.  This can create a horrible president that
would truly result in the prevention of open source driver
contributions from silicon vendors and hardware manufacturers.

Regards,

Michael Krufky
LinuxTV developer / Hauppauge Digital
