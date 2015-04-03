Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36331 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbbDCH3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 03:29:07 -0400
Date: Fri, 3 Apr 2015 09:28:33 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, sean@mess.org
Subject: Re: [PATCH 0/2] NEC scancodes and protocols in keymaps
Message-ID: <20150403072833.GA26445@hardeman.nu>
References: <20150402120047.20068.31662.stgit@zeus.muc.hardeman.nu>
 <20150402135637.28ec4dbf@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150402135637.28ec4dbf@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 02, 2015 at 01:56:37PM -0300, Mauro Carvalho Chehab wrote:
>Em Thu, 02 Apr 2015 14:02:57 +0200
>David Härdeman <david@hardeman.nu> escreveu:
>
>> The following two patches should show more clearly what I mean by
>> adding protocols to the keytables (and letting userspace add
>> keytable entries with explicit protocol information). Consider
>> it a basis for discussion.
>> 
>> Each patch has a separate description, please refer to those for
>> more information.
>
>Interesting approach. It would be good to also have a patch for
>v4l-utils rc-keycode userspace, for it to use the new way when
>available. An option to fallback to the old way would also be
>useful, in order to allow testing the backward compatibility.

Ok, yes, that'd be good to have, I'll look into it.

-- 
David Härdeman
