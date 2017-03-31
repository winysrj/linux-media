Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:48898 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932934AbdCaPFo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 11:05:44 -0400
Date: Fri, 31 Mar 2017 09:05:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Silvio Fricke <silvio.fricke@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 5/9] kernel-api.tmpl: convert it to ReST
Message-ID: <20170331090537.567730e8@lwn.net>
In-Reply-To: <0186e4eb40e09f92a7ec59f195d93af38176433f.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
        <0186e4eb40e09f92a7ec59f195d93af38176433f.1490904090.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017 17:11:32 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Brainless conversion of genericirq.tmpl book to ReST, via
> 	Documentation/sphinx/tmplcvt

This one kind of showcases why I'm nervous about bulk conversions.  It's
a bit of a dumping-ground document, with a bit of everything, and I think
we can do better.  And, in particular, this one contains a bunch of stuff
that belongs in the driver-api manual instead.  So, at a minimum, I would
really like to see this template split across those two manuals.

If you promise me a followup patch doing that, maybe I can go ahead and
merge this series now :)

(That's mildly complicated by the fact that you didn't send me parts 6,
8, and 9; I really would rather get the whole series in cases like this.)

Thanks,

jon
