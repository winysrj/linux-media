Return-path: <linux-media-owner@vger.kernel.org>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:55005 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755614Ab0BXOuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 09:50:11 -0500
Date: Wed, 24 Feb 2010 15:29:11 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans de Goede <hdegoede@redhat.com>,
	Brandon Philips <brandon@ifup.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
In-Reply-To: <4B8528F5.5010708@infradead.org>
Message-ID: <alpine.LRH.2.00.1002241526270.24061@pub3.ifh.de>
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com> <20100222225426.GC4013@jenkins.home.ifup.org> <4B839687.4090205@redhat.com>
 <4B83F635.9030501@infradead.org> <4B83F97A.60103@redhat.com> <20100224060545.GA20308@jenkins.stayonline.net> <4B851F26.4060907@redhat.com> <4B8528F5.5010708@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Wed, 24 Feb 2010, Mauro Carvalho Chehab wrote:
>> I know that was mentioned then, but re-thinking this, as this will all
>> be Linux specific, I don't really see a need for autotools atm, and as
>> I personally find autotools a bit overcomplicated. I would like to try
>> just using plain Makefiles for now. If it turns out this does not work
>> we can always switch to autotools later.
>
> I suspect it won't work fine. There are some library dependencies at
> utils/contrib, like libsysfs and libqt stuff. The build system should or
> refuse to compile or disable some of those tools if the dependencies are
> missing.

Have a look at cmake: cmake.org . It is extremely powerful in terms of 
external-library--detection, it can do QT natively and all other things 
around library generation and dependencies.

Cmake has become my favorite build-tool for user-space development.

Just my 2cts.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
