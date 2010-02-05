Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f189.google.com ([209.85.211.189]:47765 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab0BENVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2010 08:21:52 -0500
Received: by ywh27 with SMTP id 27so3324988ywh.1
        for <linux-media@vger.kernel.org>; Fri, 05 Feb 2010 05:21:51 -0800 (PST)
Message-ID: <4B6C1B60.1080905@gmail.com>
Date: Fri, 05 Feb 2010 11:21:36 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Brandon Jenkins <bcjenkins@tvwhere.com>
CC: linux-media@vger.kernel.org
Subject: Re: I don't get GIT
References: <de8cad4d1002050348h592c3ea6h5d7a3637646a4739@mail.gmail.com>
In-Reply-To: <de8cad4d1002050348h592c3ea6h5d7a3637646a4739@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Brandon,

On 02/05/2010 09:48 AM, Brandon Jenkins wrote:
> Hi Linux Media,
> 
> As an end user I am most interested in updating specific drivers for
> my system. Most distros, that I know of, only bump kernel versions by
> releasing a new version of the distro. As development move to the GIT
> repository, how do I as an end user pull the drivers and compile for
> my current running kernel? I am not too interested in compiling the
> whole kernel just to get the fixes of the drivers. NOTE: The sole
> reason this server exists is to provide TV and media distribution in
> the home.

We still have mercurial tree available which became the backport tree. 
Basically, almost daily this tree is synced with git tree and backported
some drivers to work with old kernels.

> When I read through Mauro's announcement of the GIT repository it
> seemed to indicate that this feature wasn't available. Although I
> could have read that incorrectly.

You can download the hg tree following the linuxtv wiki page:
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers#Using_Mercurial

Cheers,
Douglas
