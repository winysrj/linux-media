Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48139 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751667AbcJCPYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Oct 2016 11:24:34 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
To: linux-media@vger.kernel.org
References: <555d3aa35c4d2dd901b9fbcfdfdacce8@smtp-cloud3.xs4all.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e82f5cf1-81b7-d3c4-11cc-033d1ccd4551@xs4all.nl>
Date: Mon, 3 Oct 2016 17:24:31 +0200
MIME-Version: 1.0
In-Reply-To: <555d3aa35c4d2dd901b9fbcfdfdacce8@smtp-cloud3.xs4all.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/16 17:00, Hans Verkuil wrote:
> This message is generated daily by a cron job that builds media_tree for
> the kernels and architectures in the list below.

This was a test run for the daily build. There were still some build 
environment
issues, but I hope I solved the mistakes when I run it tonight.

Most warnings have to do with the recent constification patches: I 
haven't fixed
the media_build for that yet (might take some time before I get around 
to that).

The latest smatch/sparse have been installed and the latest 6.2 gcc 
compiler, so
everything is using the latest toolchains.

And I am slowly working towards avoiding building anything if nothing 
has changed,
but that's not yet in.

Regards,

	Hans
