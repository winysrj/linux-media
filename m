Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.229]:47692
	"HELO nm4-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751358Ab1IPK6E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 06:58:04 -0400
Message-ID: <1316170278.97174.YahooMailClassic@web86708.mail.ird.yahoo.com>
Date: Fri, 16 Sep 2011 11:51:18 +0100 (BST)
From: Stuart Morris <stuart_morris@talk21.com>
Subject: [linux-media]Re: media_build script fails for kernel 2.6.35 fc14
To: linux-media@vger.kernel.org
In-Reply-To: <1316161491.32471.YahooMailClassic@web86705.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



--- On Fri, 16/9/11, Stuart Morris <stuart_morris@talk21.com> wrote:

> From: Stuart Morris <stuart_morris@talk21.com>
> Subject: media_build script fails for kernel 2.6.35 fc14
> To: linux-media@vger.kernel.org
> Date: Friday, 16 September, 2011, 9:24
> In tda18271-common.c
> Error 'vaf' storage size unknown.
> 
> I do not get this error when building against 2.6.36
> mdv2010.2
> 
> Please can anyone suggest a work-around?
> 
> Stu-e
> 
> 

This commit appears to be the culprit:
http://git.linuxtv.org/media_tree.git/commitdiff/be85fefecb20b533a2c3f668a345f03f492aeea3

[media] tda18271: Use printk extension %pV

