Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54188 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753243Ab2ECMUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 08:20:38 -0400
Message-ID: <4FA27814.9060107@iki.fi>
Date: Thu, 03 May 2012 15:20:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, mchehab@redhat.com,
	nbowler@elliptictech.com, james.dutton@gmail.com
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
References: <20120502191324.GE852@valkosipuli.localdomain> <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi> <201205022245.22585.hverkuil@xs4all.nl> <20120502213915.GG852@valkosipuli.localdomain> <2ce6f5bbb2d0c3b1c7e9e77a2e4a89cf@chewa.net> <3b9e7aa585169179c0140508e72cf97b@chewa.net>
In-Reply-To: <3b9e7aa585169179c0140508e72cf97b@chewa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rémi Denis-Courmont wrote:
> Answering myself.
>
> On Thu, 03 May 2012 12:57:00 +0200, Rémi Denis-Courmont<remi@remlab.net>
> wrote:
>> On Thu, 3 May 2012 00:39:15 +0300, Sakari Ailus<sakari.ailus@iki.fi>
>> wrote:
>>> - ppc64: int is 64 bits there, and thus also enums,
>>
>> Really?
>
> No, really not:
> http://refspecs.linuxfoundation.org/ELF/ppc64/PPC-elf64abi-1.9.html#FUND-TYPE

Right. Someone brought that up AFAIR and I didn't check it from other 
sources. Thanks for the correction.

-- 
Sakari Ailus
sakari.ailus@iki.fi
