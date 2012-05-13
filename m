Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab2EMFqx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 01:46:53 -0400
Message-ID: <4FAF4BBA.9090904@redhat.com>
Date: Sun, 13 May 2012 07:50:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
CC: linux-media@vger.kernel.org
Subject: Re: How I must report that a driver has been broken?
References: <4FADE682.3090005@netscape.net> <4FAE1CA1.1010203@redhat.com> <4FAEB948.7080800@netscape.net>
In-Reply-To: <4FAEB948.7080800@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/12/2012 09:26 PM, Alfredo Jesús Delaiti wrote:
> Hi
>
> Thanks for your response Hans and Patrick
>
> Maybe I doing wrong this, because it reports twice:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg45199.html
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44846.html

In your last message you indicate that you've found the patch causing it,
and that you were looking into figuring which bit of the patch actually
breaks things, so I guess people reading the thread were / are
waiting for you to follow up on it with the results of your attempts
to further isolate the cause.

What I were do if I were you is send a mail directly to the author
of the patch causing the problems, with what you've discovered
about the problem sofar in there, and put the list in the CC.

Regards,

Hans
