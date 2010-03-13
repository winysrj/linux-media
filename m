Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab0CMUoe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 15:44:34 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2DKiX7S013065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 13 Mar 2010 15:44:34 -0500
Message-ID: <4B9BF92E.2070302@redhat.com>
Date: Sat, 13 Mar 2010 17:44:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pushes at v4l-utils tree
References: <4B99891E.9010406@redhat.com> <4B9A62B6.7090004@redhat.com> <4B9A962A.2020407@redhat.com> <4B9AE956.203@redhat.com> <4B9B3417.7020008@redhat.com>
In-Reply-To: <4B9B3417.7020008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
> 
> On 03/13/2010 02:24 AM, Mauro Carvalho Chehab wrote:
>> Please, don't upgrade the version yet just due to keytable, as I'm
>> still working on
>> more keytable patches, to handle the new uevent attributes (to match
>> the IR core patches
>> I posted earlier today).
>>
> 
> Ok,
> 
> Note the main reason for the 0.7.91 release was a small libv4l fix which
> I wanted to get out there.

No problem. Feel free to increase release version when you change libv4l again.
There's no hush to rise the version due to keytable, as it needs the new ir-core
patches for the new features to work.

-- 

Cheers,
Mauro
