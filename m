Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:54364 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751625AbdLLPzh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 10:55:37 -0500
Date: Tue, 12 Dec 2017 15:55:25 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Alan <alan@linux.intel.com>, vincent.hervieux@gmail.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] atomisp: Fix up the open v load race
Message-ID: <20171212155525.7ab67f2a@alans-desktop>
In-Reply-To: <20171212090350.0b57dbbb@vento.lan>
References: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
        <20171212090350.0b57dbbb@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 12 Dec 2017 09:03:50 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Em Mon, 06 Nov 2017 23:36:36 +0000
> Alan <alan@linux.intel.com> escreveu:
> 
> > This isn't the ideal final solution but it stops the main problem for now
> > where an open (often from udev) races the device initialization and we try
> > and load the firmware twice at the same time. This needless to say doesn't
> > usually end well.  
> 
> What we do on most drivers is that video_register_device() is called
> only after all hardware init.
> 
> That's usually enough to avoid race conditions with udev, although
> a mutex is also common in order to avoid some other race conditions
> between open/close - with can happen with multiple opens.

There are a whole bunch of other ordering issues to deal with in the
atomisp case beyond this - another one is that the camera probe can race
the ISP probe.

Quite a lot of the registration code needs fixing, but I'm prioritizing
stabilizing the code first, and trying to get the Cherrytrail version
going.

Alan
