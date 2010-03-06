Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53451 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0CFAv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Mar 2010 19:51:27 -0500
Received: by vws9 with SMTP id 9so2052645vws.19
        for <linux-media@vger.kernel.org>; Fri, 05 Mar 2010 16:51:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>
	 <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>
Date: Fri, 5 Mar 2010 16:51:26 -0800
Message-ID: <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>
Subject: Re: "Invalid module format"
From: VDR User <user.vdr@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 5, 2010 at 4:39 PM, Theodore Kilgore
<kilgota@banach.math.auburn.edu> wrote:
> This is to report the good news that none of the above suspicions have
> panned out. I still do not know the exact cause of the problem, but a local
> compile and install of the 2.6.33 kernel did solve the problem. Hence, it
> does seem that the most likely origin of the problem is somewhere in the
> Slackware-current tree and the solution does not otherwise concern anyone on
> this list and does not need to be pursued here.

I experienced the same problem and posted a new thread about it with
the subject "Problem with v4l tree and kernel 2.6.33".  I'm a debian
user as well so apparently whatever is causing this is not specific to
debian or slackware.  Even though you've got it working now, the
source of the problem should be investigated.
