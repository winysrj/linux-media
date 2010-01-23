Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab0AWPhP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 10:37:15 -0500
Message-ID: <4B5B17A4.6090201@redhat.com>
Date: Sat, 23 Jan 2010 13:37:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Procedures for git push
References: <4B5B08B3.50408@redhat.com> <A24693684029E5489D1D202277BE89445071D65E@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89445071D65E@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
>>
>> At the email, please always send a summary of what's being send. Such summary is produced by
>> this commands:
>>         git diff -M --stat --summary $ORIGIN `git branch |grep ^\*|cut -b3-`
>>         echo
>>         git log --pretty=short $ORIGIN..|git shortlog
>>
>> where $ORIGIN is the commit hash of the tree before your patches.
> 
> Either that, or you can use following command:
> 
> http://www.kernel.org/pub/software/scm/git/docs/git-request-pull.html

Good tip! I wrote the above commands based on my own submit script, that were written before
this command being added on -git ;)

I've updated the procedure to reflect this change.

In order to be easier for people to view the new version, I've added it at our wiki:
	http://linuxtv.org/wiki/index.php/Maintaining_Git_trees

I did one or two cosmetic changes there also, and I added an useful information on how to submit
a fix patch that should also be applied at -stable.

For those that are sending contributions, I ask to not directly update the wiki (except if the
changes are cosmetic only) but send first an email about the proposed changes at this thread,
to allow a better review of the proposed changes.

Cheers,
Mauro
