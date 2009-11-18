Return-path: <linux-media-owner@vger.kernel.org>
Received: from dns1.tnr.at ([62.99.154.7]:37555 "EHLO mail.tnr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZKRJFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:05:03 -0500
Date: Wed, 18 Nov 2009 10:05:18 +0100
From: Andreas Feuersinger <andreas.feuersinger@spintower.eu>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: Driver for NXP SAA7154
Message-ID: <20091118100518.08e147ee@devenv1>
In-Reply-To: <630a05e93817ce501eb6a0ddd6246a39.squirrel@webmail.xs4all.nl>
References: <20091118084516.375817ff@devenv1>
	<630a05e93817ce501eb6a0ddd6246a39.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thank you for your reply!

On Wed, 18 Nov 2009 09:20:53 +0100
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:
> > I wonder if there is work in progress for a Linux driver supporting
> > the NXP SAA7154 Multistandard video decoder with comb filter,
[..]
> > Datasheet:
> > http://www.nxp.com/documents/data_sheet/SAA7154E_SAA7154H.pdf

> I think it will have to be a new driver, partially based on the
> current saa7115.c driver (at least the composite/S-Video input part
> seems to be very similar to that one). The good news is that the
> datasheet is available, that will help a lot.

Is it possible for you to estimate time and effort for writing the
driver? I don't really have experience in Linux driver writing so far.
How much help could one expect?
Are there other people interested in or willing to write the driver? 

I considered asking people from Linux Driver Project for assistance...

Sorry for asking probably silly questions, I am new to the kernel
development process.

Regards,
	Andreas
