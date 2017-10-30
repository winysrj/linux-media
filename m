Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54561 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932291AbdJ3JM7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 05:12:59 -0400
Date: Mon, 30 Oct 2017 07:12:45 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANN] Agenda (v2) for the media mini-summit on Friday Oct 27 in
 Prague
Message-ID: <20171030071238.711e55ae@vela.lan>
In-Reply-To: <4361603d-7c2c-6362-662a-646ee138619c@xs4all.nl>
References: <4361603d-7c2c-6362-662a-646ee138619c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 20 Oct 2017 13:17:31 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> We are organizing a media mini-summit on Friday October 27 in Prague, co-located
> with the ELCE conference:

For those that were at our gpg sign party, don't forget to sign the
keys :-)

The way I did was to place all keys that were exchanged there at the key
party into a file named keys.txt (except for my own key). Then, I ran this
small script to import the keys to my keychain, sign them and send back to
the key server:

$ for i in $(cat keys.txt |sed 's, ,,g'); do if [ "$(gpg --list-sig $i|grep "my@address")" == "" ]; then echo $i; gpg --recv-keys $i; gpg --sign-key $i; gpg --send-keys $i; fi; done

PS.: don't forget to replace "my@address" to the email address you
use for sign keys.

Regard


Cheers,
Mauro
