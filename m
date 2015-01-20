Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42159 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbATKGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 05:06:22 -0500
Received: by mail-pd0-f173.google.com with SMTP id fp1so17212442pdb.4
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 02:06:21 -0800 (PST)
Date: Tue, 20 Jan 2015 21:06:07 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: build failure on ubuntu 14.04.1 LTS
Message-ID: <20150120100605.GA33970@shambles.windy>
References: <20150119123212.GA33475@shambles.windy>
 <54BCFC78.3030303@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BCFC78.3030303@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 19, 2015 at 01:45:44PM +0100, Hans Verkuil wrote:
> On 01/19/2015 01:32 PM, Vincent McIntyre wrote:
> > Hi
> > 
> > I am seeing build failures since 11 January.
> > A build I did on 22 December worked fine.
> > My build procedure and the error are shown below.
> 
> I've just updated media_build to stop compiling the smiapp driver for kernels
> < 3.20. So if you do 'git pull' in your media_build directory and try again
> it should work.

I can confirm that it does work now.
Thanks for the quick turnaround, much appreciated.
Vince
