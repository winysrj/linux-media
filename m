Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.45.188]:53840 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0CALh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 06:37:57 -0500
From: Julian Scheel <julian@jusst.de>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Announcing v4l-utils-0.7.90 (which includes libv4l-0.7.90)
Date: Mon, 1 Mar 2010 12:19:14 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4B882457.1050006@hhs.nl> <4B8B7BF2.4070201@redhat.com> <4B8B8857.4080100@redhat.com>
In-Reply-To: <4B8B8857.4080100@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003011219.14706.julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, 1. März 2010 10:26:47 schrieb Hans de Goede:
> >>> I'm happy to announce the first (test / beta) release of v4l-utils,
> >>> v4l-utils is the combination of various v4l and dvb utilities which
> >>> used to be part of the v4l-dvb mercurial kernel tree and libv4l.
>
> Reading some more about dvb-apps, I have to side with the people
> who are voting for keeping dvb-apps separate. I do wonder
> if those people and you and Mauro are talking about the same dvb-apps,
> or if this is just a misunderstanding.
> 
> The dvp-apps I'm talking about now, and of which I'm not in favor of
> merging them with v4l-utils are the ones, which can be downloaded
> here:
> http://linuxtv.org/downloads/
> http://linuxtv.org/hg/dvb-apps
> 
> Although I must agree with the people who are in favor of
> integrating this into v4l-utils, that this needs much more active
> maintainership wrt to making regular tarbal releases for distro's
> to consume.
> 
> Still I believe this should stay as a separate project, because
> so far it clearly was, and I see no huge advantages in integrating it.
> 
> Signs that this clearly is a separate stand alone project:
> 
> 1) It has done several tarbal releases (these are ancient guys,
>     this needs to be fixed).
> 
> 2) It has its own VCS
> 
> 3) It is packaged up by various distros:
> 
> http://packages.debian.org/sid/video/dvb-apps
> http://packages.ubuntu.com/source/dapper/linuxtv-dvb-apps
> http://cvs.fedoraproject.org/viewvc/rpms/dvb-apps/
> http://rpm.pbone.net/index.php3?stat=3&search=dvb-apps&srodzaj=3
> http://gentoo-portage.com/media-tv/linuxtv-dvb-apps
> http://aur.archlinux.org/packages.php?ID=2034
> http://www.slax.org/modules.php?action=detail&id=3143
> https://dev.openwrt.org/ticket/2804
> 
> 4) It is referenced as a standalone project by 3th parties:
> http://www.mythtv.org/wiki/Dvb-apps
> 
> 
> So given the stand alone nature, and that it is already widely packaged
> as a standalone project by distro's. For now I'm against ingrating this
> into v4l-utils.
> 
> And the most important argument for me being against this, is that one
> of the 2 active contributors (judging from the hg tree), Manu Abraham,
> is very much against integration. And the people who are in favor
> (Hans Verkuil and Mauro) don't seem to have done any commits to the
> tree in question, for at least the last 2 years.
> 
> So unless we can get some buy in for integrating this in to
> v4l-utils from active dvb-apps contributors I'm opposed to the integration.

I agree with you that dvb-apps should stay a seperate project as there are 
now. I don't see any reason for integrating them into one project with v4l-
utils. There are no developers actively working on both projects. This would 
lead to problematic release preparation for sure. Especially when keeping in 
mind that Mauro and Manu are not exactly happy with working together, so I 
really think it would be much easier to keep it seperated.
Also I don't think that all users who use dvb-apps would need to have all the 
v4l-utils and vice versa.
So please keep it seperate.
 
> With this all said, I must say: Manu please do a tarbal release real real
> soon, and make a habit out of doing so regularly!

This is of course right and should be done soon. I think this wasn't done for 
a long time due to the incompleteness of v5 API support. But afaik Manu is 
currently working on it, so it shouldn't take too long anymore.

Regards,
Julian
