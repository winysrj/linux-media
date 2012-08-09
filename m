Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1724 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2HIH3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 03:29:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: build docs fails: parser error : Failure to process entity sub-enum-freq-bands
Date: Thu, 9 Aug 2012 09:29:41 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <5022F3A5.2030507@iki.fi>
In-Reply-To: <5022F3A5.2030507@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208090929.41126.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It works for me.

make DOCBOOKS=media_api.xml htmldocs

Perhaps you need to do a make cleandocs first?

Regards,

	Hans

On Thu August 9 2012 01:17:57 Antti Palosaari wrote:
> That is from current "staging/for_v3.7"
> 
> [crope@localhost linux]$ make htmldocs
>    HTML    Documentation/DocBook/media_api.html
> warning: failed to load external entity 
> "/home/crope/linuxtv/code/linux/Documentation/DocBook/vidioc-enum-freq-bands.xml"
> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:542: 
> parser error : Failure to process entity sub-enum-freq-bands
>      &sub-enum-freq-bands;
>                           ^
> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:542: 
> parser error : Entity 'sub-enum-freq-bands' not defined
>      &sub-enum-freq-bands;
>                           ^
> warning: failed to load external entity 
> "/home/crope/linuxtv/code/linux/Documentation/DocBook/selections-common.xml"
> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:600: 
> parser error : Failure to process entity sub-selections-common
>        &sub-selections-common;
>                               ^
> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:600: 
> parser error : Entity 'sub-selections-common' not defined
>        &sub-selections-common;
>                               ^
> /home/crope/linuxtv/code/linux/Documentation/DocBook/v4l2.xml:625: 
> parser error : chunk is not well balanced
> 
> ^
> /home/crope/linuxtv/code/linux/Documentation/DocBook/media_api.xml:73: 
> parser error : Failure to process entity sub-v4l2
> &sub-v4l2;
>            ^
> /home/crope/linuxtv/code/linux/Documentation/DocBook/media_api.xml:73: 
> parser error : Entity 'sub-v4l2' not defined
> &sub-v4l2;
>            ^
> unable to parse 
> /home/crope/linuxtv/code/linux/Documentation/DocBook/media_api.xml
> /usr/bin/cp: cannot stat `*.*htm*': No such file or directory
> make[1]: *** [Documentation/DocBook/media_api.html] Error 1
> make: *** [htmldocs] Error 2
> [crope@localhost linux]$
> 
> regards
> Antti
> 
> 
