Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51502 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272AbbGXIfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 04:35:05 -0400
Message-ID: <55B1F86F.8010304@xs4all.nl>
Date: Fri, 24 Jul 2015 10:33:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>,
	Masanari Iida <standby24x7@gmail.com>
CC: mchehab@osg.samsung.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] DocBook: Fix typo in intro.xml
References: <1436830610-19316-1-git-send-email-standby24x7@gmail.com> <20150714123806.4a97894c@lwn.net>
In-Reply-To: <20150714123806.4a97894c@lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/14/2015 08:38 PM, Jonathan Corbet wrote:
> On Tue, 14 Jul 2015 08:36:50 +0900
> Masanari Iida <standby24x7@gmail.com> wrote:
> 
>> This patch fix spelling typos in intro.xml.
>> This xml file is not created from comments within source,
>> I fix the xml file.
> 
> Applied to the docs tree, thanks.

Jon, would you mind if I take this patch and let it go through the media
tree? I'd like to apply a patch on top of this one that removes the mention of
devfs.

It makes more sense in general to take patches to Documentation/DocBook/media
via the media route.

Regards,

	Hans
