Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54223 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZBCWQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 17:16:14 -0500
Date: Tue, 3 Feb 2009 16:28:08 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
In-Reply-To: <200902032209.44133.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902031625400.2103@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk> <alpine.LNX.2.00.0902031302060.1882@banach.math.auburn.edu> <20090203202307.0ae074ec@free.fr> <200902032209.44133.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Feb 2009, Adam Baker wrote:

> On Tuesday 03 February 2009, Jean-Francois Moine wrote:
>> Indeed, the problem is there! You must have only one process reading the
>> webcam! I do not see how this can work with these 2 processes...
>
> Although 2 processes are created only one ever gets used.

How do you know that? Just curious.

> create_singlethread_workqueue would therefore be less wasteful but make no
> other difference.

In at least one respect, you seem to be right. The oops still occurs. See 
my previous mail.

Theodore Kilgore

