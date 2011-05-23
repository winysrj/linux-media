Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1EWOsB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:48:01 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4NEm1l9025482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 23 May 2011 10:48:01 -0400
Received: from shalem.localdomain (vpn1-4-53.ams2.redhat.com [10.36.4.53])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p4NElxr8014537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 23 May 2011 10:48:00 -0400
Message-ID: <4DDA73A5.1080803@redhat.com>
Date: Mon, 23 May 2011 16:48:05 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-utils/master] Add an install target to libv4l2util
References: <E1QORwH-0003gY-GA@www.linuxtv.org>
In-Reply-To: <E1QORwH-0003gY-GA@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 05/23/2011 12:00 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/v4l-utils.git tree:
>
> Subject: Add an install target to libv4l2util
> Author:  Mauro Carvalho Chehab<mchehab@redhat.com>
> Date:    Mon May 23 07:00:00 2011 -0300
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>

Erm,

This is a static lib, installing static libs globally is considered
bad practice. Either we need to make this a properly versioned .so
and all the API+ABI promises which some with that, or we should just
keep it as a private utility function lib, which gets linked into
a few utils, but not installed system wide.

I think this may have something to do with the new get_media_devices
code, but the commit message is rather undescriptive...

Regards,

Hans
