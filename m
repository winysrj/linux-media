Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:2769 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZGBWAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 18:00:52 -0400
Received: by qw-out-2122.google.com with SMTP id 9so913260qwb.37
        for <linux-media@vger.kernel.org>; Thu, 02 Jul 2009 15:00:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W2753C79E5C866460426A1888340@phx.gbl>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
	 <829197380906250700s3f96262bhad95e9a758e88d3f@mail.gmail.com>
	 <COL103-W2753C79E5C866460426A1888340@phx.gbl>
Date: Thu, 2 Jul 2009 18:00:54 -0400
Message-ID: <829197380907021500ld48350bjc056a06fdc63daec@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: George Adams <g_adams27@hotmail.com>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2009 at 10:34 AM, George Adams<g_adams27@hotmail.com> wrote:
> Y'all are very kind to help - thank you.  I am indeed running Ubuntu Hardy
> (8.04.2 LTS), kernel on a quad-core Q9550 box.  I'll be happy to provide any
> other system details that may assist.  "uname -a" returns:
>
> Linux spurgeon 2.6.24-24-server #1 SMP Wed Apr 15 16:36:01 UTC 2009 i686
> GNU/Linux

George,

FYI:  The fix got merged into the mainline two days ago, so if you
update to the latest v4l-dvb code, the analog support should now be
working properly under your Ubuntu Hardy setup.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
