Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab3AAOJx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 09:09:53 -0500
Date: Tue, 1 Jan 2013 12:09:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alistair Buxton <a.j.buxton@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media-build: ./build --main-git failed
Message-ID: <20130101120910.185eea81@redhat.com>
In-Reply-To: <CAO-Op+E5tRN-iJ34SGZecF3HihpAEhZnADWVpQb8+QcZBYLFMg@mail.gmail.com>
References: <CAO-Op+Es6nNRXajXdr=18jiPZTNGuZcOZ4p5UXD5ZRoN2tzobQ@mail.gmail.com>
	<CAO-Op+E5tRN-iJ34SGZecF3HihpAEhZnADWVpQb8+QcZBYLFMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Dec 2012 19:50:47 +0000
Alistair Buxton <a.j.buxton@gmail.com> escreveu:

> Output:
> 
> al@al-desktop:~/Source$ git clone git://linuxtv.org/media_build.git
> Cloning into 'media_build'...
> remote: Counting objects: 1760, done.
> 
> 
> remote: Compressing objects: 100% (560/560), done.
> remote: Total 1760 (delta 1182), reused 1727 (delta 1161)
> Receiving objects: 100% (1760/1760), 416.13 KiB | 676 KiB/s, done.
> Resolving deltas: 100% (1182/1182), done.
> 
> 
> al@al-desktop:~/Source/media_build$ ./build --main-git
> Checking if the needed tools for Ubuntu 12.10 are available
> Needed package dependencies are met.
> ************************************************************
> * building git://linuxtv.org/media_tree.git       git tree *
> ************************************************************
> ************************************************************
> * All drivers and build system are under GPLv2 License     *
> * Firmware files are under the license terms found at:     *
> * http://www.linuxtv.org/downloads/firmware/               *
> * Please abort if you don't agree with the license         *
> ************************************************************
> 
> Getting the latest Kernel tree. This will take some time
> Cloning into 'media'...
> remote: Counting objects: 2829101, done.
> remote: Compressing objects: 100% (428125/428125), done.
> remote: Total 2829101 (delta 2375344), reused 2827313 (delta 2373599)
> Receiving objects: 100% (2829101/2829101), 579.82 MiB | 787 KiB/s, done.
> Resolving deltas: 100% (2375344/2375344), done.
> Checking out files: 100% (41507/41507), done.
> adding remote r_media_tree to track git://linuxtv.org/media_tree.git,
> staging/for_v3.6
> updating remote media_tree
> Fetching r_media_tree
> remote: Counting objects: 21763, done.
> remote: Compressing objects: 100% (4889/4889), done.
> remote: Total 19160 (delta 16679), reused 16503 (delta 14249)
> Receiving objects: 100% (19160/19160), 3.55 MiB | 943 KiB/s, done.
> Resolving deltas: 100% (16679/16679), completed with 1145 local objects.
> From git://linuxtv.org/media_tree
>  * [new branch]      devel/bkl  -> r_media_tree/devel/bkl
>  * [new branch]      master     -> r_media_tree/master
>  * [new branch]      staging/for_2.6.38-rc1 ->
> r_media_tree/staging/for_2.6.38-rc1
>  * [new branch]      staging/for_v2.6.37-rc1 ->
> r_media_tree/staging/for_v2.6.37-rc1
>  * [new branch]      staging/for_v2.6.38 -> r_media_tree/staging/for_v2.6.38
>  * [new branch]      staging/for_v2.6.39 -> r_media_tree/staging/for_v2.6.39
>  * [new branch]      staging/for_v2.6.40 -> r_media_tree/staging/for_v2.6.40
>  * [new branch]      staging/for_v2.6.40-rc ->
> r_media_tree/staging/for_v2.6.40-rc
>  * [new branch]      staging/for_v3.0 -> r_media_tree/staging/for_v3.0
>  * [new branch]      staging/for_v3.1 -> r_media_tree/staging/for_v3.1
>  * [new branch]      staging/for_v3.2 -> r_media_tree/staging/for_v3.2
>  * [new branch]      staging/for_v3.3 -> r_media_tree/staging/for_v3.3
>  * [new branch]      staging/for_v3.4 -> r_media_tree/staging/for_v3.4
>  * [new branch]      staging/for_v3.5 -> r_media_tree/staging/for_v3.5
>  * [new branch]      staging/for_v3.6 -> r_media_tree/staging/for_v3.6
>  * [new branch]      staging/for_v3.7 -> r_media_tree/staging/for_v3.7
>  * [new branch]      staging/for_v3.8 -> r_media_tree/staging/for_v3.8
>  * [new branch]      staging/for_v3.9 -> r_media_tree/staging/for_v3.9
>  * [new branch]      staging/leadership -> r_media_tree/staging/leadership
>  * [new branch]      staging/v2.6.35 -> r_media_tree/staging/v2.6.35
>  * [new branch]      staging/v2.6.36 -> r_media_tree/staging/v2.6.36
>  * [new branch]      staging/v2.6.37 -> r_media_tree/staging/v2.6.37
> creating a local branch media_tree
> Branch media_tree/staging/for_v3.6 set up to track remote branch
> staging/for_v3.6 from r_media_tree.
> Switched to a new branch 'media_tree/staging/for_v3.6'
> make: Entering directory `/home/al/Source/media_build/linux'
> rm -rf drivers firmware include sound .patches_applied .linked_dir
> .git_log.md5 git_log kernel_version.h
> ../media/ does not contain kernel sources
> /bin/sh: 1: exit: Illegal number: -1
> make: *** [dir] Error 2
> make: Leaving directory `/home/al/Source/media_build/linux'
> Can't link the building system to the media directory. at ./build line 414.
> al@al-desktop:~/Source/media_build$
> 
> Analysis:
> 
> ./build, line 18: my $main_branch = "staging/for_v3.6";
> This is the branch that gets checked out.

Updated to for_v3.9. 

Thanks for reporting it.

Regards,
Mauro
