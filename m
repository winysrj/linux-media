Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1GNQRn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 12:17:43 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EGHg5s001934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 12:17:43 -0400
Message-ID: <4E1F1694.4040605@redhat.com>
Date: Thu, 14 Jul 2011 12:17:24 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] imon: rate-limit send_packet spew
References: <1310594321-12921-1-git-send-email-jarod@redhat.com> <4E1F1564.9060502@redhat.com>
In-Reply-To: <4E1F1564.9060502@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em 13-07-2011 18:58, Jarod Wilson escreveu:
>> There are folks with flaky imon hardware out there that doesn't always
>> respond to requests to write to their displays for some reason, which
>> can flood logs quickly when something like lcdproc is trying to
>> constantly update the display, so lets rate-limit all that error spew.
>
> This patch caused a compilation error here:
>
> drivers/media/rc/imon.c: In function ‘send_packet’:
> drivers/media/rc/imon.c:519: warning: type defaults to ‘int’ in declaration of ‘DEFINE_RATELIMIT_STATE’
> drivers/media/rc/imon.c:519: warning: parameter names (without types) in function declaration

D'oh, sorry. Missing the <linux/ratelimit.h> #include... Will send a 
proper v2 after lunch (and a compile sanity-check).

-- 
Jarod Wilson
jarod@redhat.com


