Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:13122
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbbDEMOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2015 08:14:44 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, HPDD-discuss@lists.01.org,
	alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
	linux-input@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/16] fix error return code
Date: Sun,  5 Apr 2015 14:06:20 +0200
Message-Id: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The complate semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@ok exists@
identifier f,ret,i;
expression e;
constant c;
@@

// identify a function that returns a negative return value at least once.
f(...) {
... when any
(
return -c@i;
|
ret = -c@i;
... when != ret = e
return ret;
|
if (ret < 0) { ... return ret; }
)
... when any
}

@r exists@
identifier ret,ok.f,fn;
expression e1,e2,e3,e4,e5,e6,x;
statement S,S1;
position p1,p2,p3;
@@

// identify a case where the return variable is set to a non-negative value
// and then returned in error-handling code
f(...) {
... when any
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != \(ret = e1\|ret++\|ret--\|ret+=e1\|ret-=e1\)
    when != &ret
    when any
(
 if (<+... ret = e5 ...+>) S1
|
 if (<+... &ret ...+>) S1
|
if@p2(<+...x = fn(...)...+>)
 {
  ... when != ret = e6
      when forall
 return@p3 ret;
}
|
break;
|
x = fn(...)
... when != \(ret = e4\|ret++\|ret--\|ret+=e4\|ret-=e4\)
    when != &ret
(
 if (<+... ret = e3 ...+>) S
|
 if (<+... &ret ...+>) S
|
if@p2(<+...\(x != 0\|x < 0\|x == NULL\|IS_ERR(x)\)...+>)
 {
  ... when != ret = e2
      when forall
 return@p3 ret;
}
)
)
... when any
}

@printer depends on r@
position p;
identifier ok.f,pr;
constant char [] c;
@@

f(...) { <...pr@p(...,c,...)...> }

@bad0 exists@
identifier r.ret,ok.f,g != {ERR_PTR,IS_ERR};
position p != printer.p;
@@

f(...) { ... when any
g@p(...,ret,...)
... when any
 }

@bad depends on !bad0 exists@
position r.p1,r.p2;
statement S1,S2;
identifier r.ret;
expression e1;
@@

// ignore the above if there is some path where the variable is set to
// something else
(
if@p1 (\(ret < 0\|ret != 0\)) S1
|
ret@p1 = 0
)
... when any
 \(ret = e1\|ret++\|ret--\|ret+=e1\|ret-=e1\|&ret\)
... when any
if@p2(...) S2

@bad1 depends on !bad0 && !bad exists@
position r.p2;
statement S2;
identifier r.ret;
expression e1;
constant c;
@@

ret = -c
... when != \(ret = e1\|ret++\|ret--\|ret+=e1\|ret-=e1\)
    when != &ret
    when any
if@p2(...) S2

@bad2 depends on !bad0 && !bad && !bad1 exists@
position r.p1,r.p2;
identifier r.ret;
expression e1;
statement S2;
constant c;
@@

// likewise ignore it if there has been an intervening return
ret@p1 = 0
... when != if (...) { ... ret = e1 ... return ret; }
    when != if (...) { ... return -c; }
    when any
if@p2(...) S2

@script:python depends on !bad0 && !bad && !bad1 && !bad2@
p1 << r.p1;
p2 << r.p2;
p3 << r.p3;
@@

cocci.print_main("",p1)
cocci.print_secs("",p2)
cocci.print_secs("",p3)
// </smpl>

