Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59784
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbcJOQiq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 12:38:46 -0400
Date: Sat, 15 Oct 2016 13:38:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 00/57] don't break long lines on strings
Message-ID: <20161015133840.7b5755a2@vento.lan>
In-Reply-To: <20161015154614.67f97a81@kant>
References: <cover.1476475770.git.mchehab@s-opensource.com>
        <20161015154614.67f97a81@kant>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Oct 2016 15:46:14 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> escreveu:

> On Oct 14 Mauro Carvalho Chehab wrote:
> > There are lots of drivers on media that breaks long line strings in order to
> > fit into 80 columns. This was an usual practice to make checkpatch happy.  
> 
> This was practice even before checkpatch existed.

True, but before checkpatch, we didn't care much to enforce breaking
long string lines, letting up to the patch author to decide. As far
as I remember, on media subsystem, only a handful drivers were actually
breaking long strings (or even respecting the 80 cols limit). 

After checkpatch, we started to enforce such practice, until some discussions 
on LKML arguing that breaking long strings actually make more harm than good,
as it makes harder to use grep to identify what part of the Kernel produced
a certain log message.

Thanks,
Mauro
