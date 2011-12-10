Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1LJNIe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:08:34 -0500
Message-ID: <4EE359CF.7090707@redhat.com>
Date: Sat, 10 Dec 2011 11:08:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 00/10] Query DVB frontend delivery capabilities
References: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com>
In-Reply-To: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 02:41, Manu Abraham wrote:
> Hi,
>
>   As discussed prior, the following changes help to advertise a
>   frontend's delivery system capabilities.
>
>   Sending out the patches as they are being worked out.
>
>   The following patch series are applied against media_tree.git
>   after the following commit
>
>   commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
>   Author: Hans Verkuil<hans.verkuil@cisco.com>
>   Date:   Tue Nov 8 11:02:34 2011 -0300
>
>      [media] V4L menu: add submenu for platform devices


A separate issue: please, don't send patches like that as attachment. It makes
hard for people review. Instead, you should use git send-email. There's even
an example there (at least on git version 1.7.8) showing how to set it for
Google:

$ git help send-email
...
EXAMPLE
    Use gmail as the smtp server
        To use git send-email to send your patches through the GMail SMTP server, edit ~/.gitconfig to specify your
        account settings:

            [sendemail]
                    smtpencryption = tls
                    smtpserver = smtp.gmail.com
                    smtpuser = yourname@gmail.com
                    smtpserverport = 587

        Once your commits are ready to be sent to the mailing list, run the following commands:

            $ git format-patch --cover-letter -M origin/master -o outgoing/
            $ edit outgoing/0000-*
            $ git send-email outgoing/*

        Note: the following perl modules are required Net::SMTP::SSL, MIME::Base64 and Authen::SASL
...

In practice, I generally just do this here:
	$ git send-email [some obj reference]

For example, when I want to send the last 3 patches, I just do:
	$ git send-email HEAD^1^1^1

Regards,
Mauro.
