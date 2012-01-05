Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43918 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2AEQkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 11:40:55 -0500
Received: by vbbfc26 with SMTP id fc26so511620vbb.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 08:40:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
Date: Thu, 5 Jan 2012 11:40:54 -0500
Message-ID: <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to one frontend
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 5, 2012 at 10:37 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> With all these series applied, it is now possible to use frontend 0
> for all delivery systems. As the current tools don't support changing
> the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
> be used to change between them:

Hi Mauro,

While from a functional standpoint I think this is a good change (and
we probably should have done it this way all along), is there not
concern that this could be interpreted by regular users as a
regression?  Right now they get two frontends, and they can use all
their existing tools.  We're moving to a model where if users upgraded
their kernel they would now require some new userland tool to do
something that the kernel was allowing them to do previously.

Sure, it's not "ABI breakage" in the classic sense but the net effect
is the same - stuff that used to work stops working and now they need
new tools or to recompile their existing tools to include new
functionality (which as you mentioned, none of those tools have
today).

Perhaps you would consider some sort of module option that would let
users fall back to the old behavior?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
