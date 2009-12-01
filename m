Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:62481 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZLAO7U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 09:59:20 -0500
Received: from pub6.ifh.de (pub6.ifh.de [141.34.15.118])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id nB1ExK7d015326
	for <linux-media@vger.kernel.org>; Tue, 1 Dec 2009 15:59:20 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by pub6.ifh.de (Postfix) with ESMTP id 1F45A300124
	for <linux-media@vger.kernel.org>; Tue,  1 Dec 2009 15:59:20 +0100 (CET)
Date: Tue, 1 Dec 2009 15:59:20 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Replace Mercurial with GIT as SCM
Message-ID: <alpine.LRH.2.00.0912011003480.30797@pub3.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I would like to start a discussion which ideally results in either 
changing the SCM of v4l-dvb to git _or_ leaving everything as it is today 
with mercurial.

To start right away: I'm in favour of using GIT because of difficulties I 
have with my "daily" work with v4l-dvb. It is in my nature do to mistakes, 
so I need a tool which assists me in fixing those, I have not found a 
simple way to do my stuff with HG.

I'm helping out myself using a citation from which basically describes why 
GIT fits the/my needs better than HG (*):

"The culture of mercurial is one of immutability. This is quite a good
thing, and it's one of my favorite aspects of gnu arch. If I commit
something, I like to know that it's going to be there. Because of this,
there are no tools to manipulate history by default.

git is all about manipulating history. There's rebase, commit amend,
reset, filter-branch, and probably other commands I'm not thinking of,
many of which make it into day-to-day workflows. Then again, there's
reflog, which adds a big safety net around this mutability."

The first paragraph here describes exactly my problem and the second 
descibes how to solve it.

My suggestion is not to have the full Linux Kernel source as a new base 
for v4l-dvb development, but "only" to replace the current v4l-dvb hg with 
a GIT one. Importing all the history and everything.

Unfortunately it will change nothing for Mauro's job.

I also understand that it does not give a lot to people who haven't used 
GIT until now other than a new SCM to learn. But believe me, once you've 
done a rebase when Mauro has asked you to rebuild your tree before he can 
merge it, you will see what I mean.

I'm waiting for comments.

Thanks,

(*)
http://www.rockstarprogrammer.org/post/2008/apr/06/differences-between-mercurial-and-git/

--

Patrick
http://www.kernellabs.com/
