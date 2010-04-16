Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46011 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab0DPU4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 16:56:42 -0400
Date: Fri, 16 Apr 2010 22:56:38 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 5/8] ir-core: convert mantis from ir-functions.c
Message-ID: <20100416205638.GA2873@hardeman.nu>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
 <20100415214620.14142.19939.stgit@localhost.localdomain>
 <u2x1a297b361004151617gbd08bc10l4fa202ab8dcec306@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <u2x1a297b361004151617gbd08bc10l4fa202ab8dcec306@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 16, 2010 at 03:17:35AM +0400, Manu Abraham wrote:
> On Fri, Apr 16, 2010 at 1:46 AM, David Härdeman <david@hardeman.nu> wrote:
> > Convert drivers/media/dvb/mantis/mantis_input.c to not use ir-functions.c
> > (The driver is anyway not complete enough to actually use the subsystem yet).
> 
> Huh ? I don't follow what you imply here ..
> 

The mantis_input.c file seems to be a skeleton as far as I could 
tell...not actually in use yet. Or am I mistaken?

-- 
David Härdeman
