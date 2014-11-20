Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKTUWL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 15:22:11 -0500
Message-ID: <546E4D6B.30100@redhat.com>
Date: Thu, 20 Nov 2014 21:22:03 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: v4l-utils stable release 1.6.1
References: <546E093D.4030203@googlemail.com>
In-Reply-To: <546E093D.4030203@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/20/2014 04:31 PM, Gregor Jasny wrote:
> Hello,
> 
> do you consider something from these commits as important enough for a bugfix release?
> 

<snip>

>> Hans de Goede (2):
>>       rc_keymaps: allwinner: S/KEY_HOME/KEY_HOMEPAGE/
>>       v4lconvert: Fix decoding of jpeg data with no vertical sub-sampling

Yes both of them (first one is not that important, but if you're doing
a 1.6.1 anyways it is good to include it).

Regards,

Hans
