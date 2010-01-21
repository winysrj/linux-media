Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0AUUPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 15:15:19 -0500
Message-ID: <4B58B5CE.6090909@infradead.org>
Date: Thu, 21 Jan 2010 18:15:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Brandon Philips <brandon@ifup.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org> <20100121024605.GK4015@jenkins.home.ifup.org> <201001210834.28112.hverkuil@xs4all.nl>
In-Reply-To: <201001210834.28112.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Thursday 21 January 2010 03:46:05 Brandon Philips wrote:
>> On 00:07 Thu 21 Jan 2010, Mauro Carvalho Chehab wrote:
>>> Brandon Philips wrote:

>> So here is how I see v4l-utils.git being laid out based on what others
>> have said:
>>
>>  libv4l1/
>>  libv4l2/
>>  libv4lconvert/
>>  test/
>>  v4l2-dbg/
>>  contrib/
>>   qv4l2-qt3/
>>   qv4l2-qt4/
>>   cx25821/
>>   etc... everything else
> 
> Hmm. I think I would prefer to have a structure like this:
> 
> lib/
> 	libv4l1/
> 	libv4l2/
> 	libv4lconvert/

I don't have a strong opinion if we should have a /lib dir here or
not.

> utils/
> 	v4l2-dbg
> 	v4l2-ctl
> 	cx18-ctl
> 	ivtv-ctl

	keytable
	v4l2-sysfs-path
parsers/
	parse_em28xx.pl
	parse-sniffusb2.pl

> 	test/
> 	everything else

I like the idea of putting everything else under
	contrib/

> And everything in lib and utils can be packaged by distros, while contrib
> is not packaged.

With respect to the parsers (parse_em28xx.pl and parse-sniffusb2.pl), in practice, they
seemed more important than the v4l2-dbg, as they help to check what GPIO's are needed
to support the USB devices (and it is impractical to send us a non-parsed log, due to its
very long size). So, IMO, this should be installed on distros.

> What would also be nice is if this project http://v4l-test.sourceforge.net/
> could eventually be merged in v4l2-apps.

Agreed.

Cheers,
Mauro.
