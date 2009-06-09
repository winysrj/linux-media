Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:54371 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZFIG5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 02:57:25 -0400
Received: by ewy6 with SMTP id 6so4878298ewy.37
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2009 23:57:26 -0700 (PDT)
Message-ID: <4A2E07D1.3070901@gmail.com>
Date: Tue, 09 Jun 2009 08:57:21 +0200
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] SkyStar HD2 issues, signal sensitivity, etc.
References: <621110570904131518w220106d7u67934966dbb8c7dd@mail.gmail.com> <49E3D16E.3070307@gmail.com>
In-Reply-To: <49E3D16E.3070307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Manu Abraham wrote:
> The s2-liplianin tree doesn't use an updated tree for the mantis
> based devices unfortunately. It is stuck with older changesets of
> the mantis tree.
>
> The s2-liplianin tree contains (ed) ? some clock related changes
> which were not favourable for the STB0899 demodulator, which is
> capable of causing potential hardware damage.
>   
Is this still valid that s2-liplianin tree is out of date and if so, 
does anyone have a patch to update it?
It's does not sound so good when we start talking about hardware damage.

I have a problem with the recent s2-liplianin that the driver stops 
working and both scanning and tuning fails and a reboot does not help
and I have to poweroff my computer and restart it for it to work again.
Has anyone had the same issue? It's running on a Gigabyte GA M56S S3 
motherboard if that's any help.

Regards
Claes Lindblom
