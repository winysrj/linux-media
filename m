Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:45065 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZBSRPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 12:15:15 -0500
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: Markus Rechberger <mrechberger@gmail.com>
Subject: Re: [PATCH] em28xx: register device to soundcard for sysfs
Date: Thu, 19 Feb 2009 18:15:16 +0100
Cc: Linux Media <linux-media@vger.kernel.org>
References: <200902191741.57767.nsoranzo@tiscali.it> <d9def9db0902190857p331d7667td0900ec6e8a9c75f@mail.gmail.com>
In-Reply-To: <d9def9db0902190857p331d7667td0900ec6e8a9c75f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902191815.16460.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alle giovedì 19 febbraio 2009, Markus Rechberger ha scritto:
> On Thu, Feb 19, 2009 at 5:41 PM, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > As explained in "Writing an ALSA driver" (T. Iwai),
>
> when writing a patch write the truth about where it comes from, eg.
> the author of the patch.

I'm sorry Markus, but you're just the inspirer of the patch.
I wanted to use your code and so two weeks ago I asked you twice privately if 
it was ok for you, and you didn't answer me.
Then I checked the documentation cited above, changed the one-line patch to be 
more general and now it does not contain code from your tree anymore.

Anyway, thanks for the idea
Nicola

