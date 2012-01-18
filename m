Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56687 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab2ARNCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 08:02:05 -0500
Received: by wibhm6 with SMTP id hm6so2170334wib.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 05:02:04 -0800 (PST)
Message-ID: <4F16C2CA.2090401@googlemail.com>
Date: Wed, 18 Jan 2012 14:02:02 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-utils migrated to autotools
References: <4F134701.9000105@googlemail.com> <4F16B8CC.3010503@redhat.com> <4F16BF4D.4070404@googlemail.com> <4F16C11F.3040108@redhat.com>
In-Reply-To: <4F16C11F.3040108@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/18/12 1:54 PM, Mauro Carvalho Chehab wrote:
> Em 18-01-2012 10:47, Gregor Jasny escreveu:
>> On 1/18/12 1:19 PM, Mauro Carvalho Chehab wrote:
>>> It would be nice to write at the INSTALL what dependencies are needed for
>>> the autotools to work, or, alternatively, to commit the files generated
>>> by the autoreconf -vfi magic spell there [1].
>>
>> The end user gets a tarball created with "make dist" which contains all the m4 files.
>
> Ah, ok. It probably makes sense then to add some scripting at the server to do
> a daily build, as the tarballs aren't updated very often. They're updated only
> at the sub-releases:
> 	http://linuxtv.org/downloads/v4l-utils/

Judging from the upside-down reports: not the lack of a buildable 
tarball but the lack of updated distribution packages is a problem. For 
Ubuntu we have a PPA repository with nightly builds:

https://launchpad.net/~libv4l/+archive/development

Do you have similar infrastructure for Fedora / RedHat, too?

Thanks,
Gregor
