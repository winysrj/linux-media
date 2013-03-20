Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtp18-05-2.prod.phx3.secureserver.net ([173.201.193.190]:34435
	"EHLO p3plwbeout18-05.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3CTPRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 11:17:50 -0400
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Message-Id: <20130320081748.e7c3a0fec861aa4693105436139f36a5.bc86de8fba.wbe@email18.secureserver.net>
From: <leo@lumanate.com>
To: linux-media@vger.kernel.org
Subject: "./build --main-git" failed
Date: Wed, 20 Mar 2013 08:17:48 -0700
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linux-media,

I'm getting a fatal error with the "./build --main-git" command (see log
below).
Please help!

Thank you,
-Leo.



leo@ubaduba:~/ltv3$ git clone git://linuxtv.org/media_build.git
Cloning into 'media_build'...
remote: Counting objects: 1859, done.
remote: Compressing objects: 100% (567/567), done.
remote: Total 1859 (delta 1259), reused 1846 (delta 1253)
Receiving objects: 100% (1859/1859), 426.07 KiB | 216 KiB/s, done.
Resolving deltas: 100% (1259/1259), done.
leo@ubaduba:~/ltv3$ cd media_build/
leo@ubaduba:~/ltv3/media_build$ ./build --main-git --verbose
Checking if the needed tools for Ubuntu 12.10 are available
Needed package dependencies are met.
************************************************************
* building git://linuxtv.org/media_tree.git       git tree *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort if you don't agree with the license         *
************************************************************

Getting the latest Kernel tree. This will take some time
Cloning into 'media'...
remote: Counting objects: 2938065, done.
remote: Compressing objects: 100% (455617/455617), done.
Receiving objects: 100% (2938065/2938065), 607.66 MiB | 1.63 MiB/s,
done.
remote: Total 2938065 (delta 2468257), reused 2924194 (delta 2454627)
Resolving deltas: 100% (2468257/2468257), done.
Checking out files: 100% (42425/42425), done.
$ git --git-dir media/.git remote
adding remote r_media_tree to track git://linuxtv.org/media_tree.git,
staging/for_v3.9
$ git --git-dir media/.git remote add r_media_tree
git://linuxtv.org/media_tree.git staging/for_v3.9
updating remote media_tree
Fetching r_media_tree
remote: Counting objects: 1847, done.
remote: Compressing objects: 100% (617/617), done.
remote: Total 1549 (delta 1376), reused 1044 (delta 932)
Receiving objects: 100% (1549/1549), 229.24 KiB | 116 KiB/s, done.
Resolving deltas: 100% (1376/1376), completed with 211 local objects.
>From git://linuxtv.org/media_tree
 * [new branch]      master     -> r_media_tree/master
 * [new branch]      origin     -> r_media_tree/origin
 * [new tag]         staging/for_v2.6.37-rc1 -> staging/for_v2.6.37-rc1
 * [new tag]         staging/for_v3.3 -> staging/for_v3.3
 * [new tag]         staging/for_v3.5 -> staging/for_v3.5
 * [new tag]         staging/for_v3.6 -> staging/for_v3.6
 * [new tag]         staging/for_v3.7 -> staging/for_v3.7
 * [new tag]         staging/for_v3.8 -> staging/for_v3.8
 * [new tag]         staging/for_v3.9 -> staging/for_v3.9
 * [new tag]         staging/v2.6.35 -> staging/v2.6.35
creating a local branch media_tree
$ git --git-dir media/.git branch
$ (cd media; git checkout -b media_tree/staging/for_v3.9
remotes/r_media_tree/staging/for_v3.9)
fatal: git checkout: updating paths is incompatible with switching
branches.
Did you intend to checkout 'remotes/r_media_tree/staging/for_v3.9' which
can not be resolved as commit?
Can't create local branch media_tree at ./build line 405.

