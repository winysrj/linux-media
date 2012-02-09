Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:56497 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2BIKpT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Feb 2012 05:45:19 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: kernel-janitors@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] use devm_ functions
Date: Thu,  9 Feb 2012 11:45:10 +0100
Message-Id: <1328784311-27272-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The semantic patch (http://coccinelle.lip6.fr/) used in generating this
patch is as follows.  Some manual cleanup was required.  This improves on
the previous version in that allocated values are allowed to be renamed
before they are freed.

virtual after_start
virtual returned
virtual arg
virtual get

// ---------------------------------------------------------------------
// find functions

@plat depends on !after_start@
identifier i,pfn,rfn;
position p;
@@

struct platform_driver i@p = {
  .probe = pfn,
  .remove = (<+...rfn...+>),
};

// ---------------------------------------------------------------------
// set up iteration

@initialize:ocaml@

type ret = UseReturned | UseReturned2 of string | UseArg | UseGet

let add pfn rfn alloc free devm_alloc file rule =
   let it = new iteration() in
   it#set_files [file];
   it#add_virtual_rule After_start;
   (match rule with
      UseReturned -> it#add_virtual_rule Returned
    | UseReturned2(free) -> it#add_virtual_rule Returned;
      it#add_virtual_identifier Second_free free
    | UseArg -> it#add_virtual_rule Arg
    | UseGet -> it#add_virtual_rule Get);
   if not (pfn="") then it#add_virtual_identifier Pfn pfn;
   if not (rfn="") then it#add_virtual_identifier Rfn rfn;
   if not (alloc="") then it#add_virtual_identifier Alloc alloc;
   if not (free="") then it#add_virtual_identifier Free free;
   if not (devm_alloc="") then it#add_virtual_identifier Devm_alloc devm_alloc;
   it#register()

@script:ocaml@
pfn << plat.pfn;
rfn << plat.rfn;
p << plat.p;
@@

let file = (List.hd p).file in
add pfn rfn "kmalloc" "kfree" "devm_kzalloc" file UseReturned;
add pfn rfn "kzalloc" "kfree" "devm_kzalloc" file UseReturned;
add pfn rfn "ioremap" "iounmap" "devm_ioremap" file UseReturned;
add pfn rfn "ioremap_nocache" "iounmap" "devm_ioremap_nocache" file
   UseReturned;

add pfn rfn "request_irq" "free_irq" "devm_request_irq" file UseArg;
add pfn rfn "request_threaded_irq" "free_irq" "devm_request_threaded_irq" file
  UseArg;
add pfn rfn "dma_alloc_coherent" "dma_free_coherent" "dmam_alloc_coherent"
  file UseArg;
add pfn rfn "dma_alloc_noncoherent" "dma_free_noncoherent"
  "dmam_alloc_noncoherent" file UseArg;

(* several possibilities... *)
add pfn rfn "request_region" "release_region" "devm_request_region" file
  UseGet;
add pfn rfn "request_mem_region" "release_mem_region"
  "devm_request_mem_region" file UseGet;
add pfn rfn "request_region" "release_region" "devm_request_region" file
  UseArg;
add pfn rfn "request_mem_region" "release_mem_region"
  "devm_request_mem_region" file UseArg;
(* fix a bug at the same time *)
add pfn rfn "request_region" "release_resource" "devm_request_region" file
  (UseReturned2("kfree"));
add pfn rfn "request_mem_region" "release_resource"
  "devm_request_mem_region" file (UseReturned2("kfree"));
add pfn rfn "ioport_map" "ioport_unmap" "devm_ioport_map" file UseReturned

// ---------------------------------------------------------------------
// process the initial definition of the probe function

@preprobe@
identifier virtual.pfn;
position p;
@@

pfn@p(...) { ... }

@probe@
identifier pfn;
position preprobe.p;
@@

pfn@p(...) { ... }

@labelled_return@
identifier probe.pfn,l;
expression e;
@@

pfn(...) { <+... l: return e; ...+> }

// ---------------------------------------------------------------------
// transform functions where free uses the result

@prb depends on returned exists@
identifier probe.pfn,pdev,virtual.alloc,virtual.free,virtual.second_free;
expression x,y,e;
expression list args;
position p1,p2,p3;
type T1,T2,T3;
@@

pfn(struct platform_device *pdev) { ... when any
x = (T1)alloc@p1(args)
<... when strict
     when any
     when forall
(
y = x;
... when != y = e
    when != &y
free@p2((T2)y,...);
... when != x
    when != y
second_free@p3((T3)y,...);
|
y = x;
... when != y = e
    when != &y
free@p2((T2)y,...);
|
free@p2((T2)x,...);
... when != x
second_free@p3((T3)x,...);
|
free@p2((T2)x,...);
)
...>
}

@reme exists@
identifier virtual.rfn,virtual.free;
expression prb.x,prb.y;
type T;
@@

rfn(...) { ... free((T)\(x\|y\),...); ... }

@rem depends on reme@
identifier virtual.rfn,virtual.free,virtual.second_free;
expression prb.x,prb.y;
position p4,p5;
type T,T1;
@@

rfn(...) {
<... when strict
(
free@p4((T)\(x\|y\),...);
... when != x
second_free@p5((T1)\(x\|y\),...);
|
free@p4((T)\(x\|y\),...);
)
...>
}

@bad@
identifier virtual.free;
expression prb.x,prb.y;
position p != {prb.p2,rem.p4};
type T;
@@

free@p((T)\(x\|y\),...)

@modif depends on rem && !bad@
expression x;
identifier prb.pdev,virtual.alloc,virtual.free,virtual.devm_alloc;
identifier virtual.second_free;
expression list args;
position prb.p1,prb.p2,prb.p3,rem.p4,rem.p5;
type T;
@@

(
- free@p2(...);
|
- second_free@p3(...);
|
- free@p4(...);
|
- second_free@p5(...);
|
  x =
- alloc@p1(
+ devm_alloc(&pdev->dev,
    args)
|
  x = 
- (T)alloc@p1(
+ (T)devm_alloc(&pdev->dev,
    args)
)

// ---------------------------------------------------------------------
// transform functions where free uses the first argument

@prbx depends on arg exists@
identifier probe.pfn,pdev,virtual.alloc,virtual.free;
expression x,y,e;
expression list args;
position p1,p2;
@@

pfn(struct platform_device *pdev) { ... when any
alloc@p1(x,args)
<... when strict
     when any
     when forall
(
y = x;
... when != y = e
    when != &y
free@p2(y,...);
|
free@p2(x,...)
)
...>
}

@remxe exists@
identifier virtual.rfn, virtual.free;
expression prbx.x,prbx.y;
@@

rfn(...) { ... free(\(x\|y\),...); ... }

@remx depends on remxe@
identifier virtual.rfn, virtual.free;
expression prbx.x,prbx.y;
position p3;
@@

rfn(...) {
<... when strict
free@p3(\(x\|y\),...)
...>
}

@badx@
identifier virtual.free;
expression prbx.x,prbx.y;
position p != {prbx.p2,remx.p3};
@@

free@p(\(x\|y\),...)

@modifx depends on remx && !badx@
expression x;
identifier prbx.pdev,virtual.alloc,virtual.free,virtual.devm_alloc;
expression list args;
position prbx.p1,prbx.p2,remx.p3;
@@

(
- free@p2(...);
|
- free@p3(...);
|
- alloc@p1(
+ devm_alloc(&pdev->dev,
   x,args)
)

// ---------------------------------------------------------------------
// transform functions where free uses the result of platform_get_resource

@prbg depends on get exists@
identifier probe.pfn,pdev,virtual.alloc,virtual.free;
expression x,y,e;
expression list args;
position p1,p2;
@@

pfn(struct platform_device *pdev) { ... when any
alloc@p1(x,args)
<... when strict
     when any
     when forall
(
y = x;
... when != y = e
    when != &y
free@p2(y,...);
|
free@p2(x,...)
)
...>
}

@remge exists@
identifier virtual.rfn, virtual.free;
identifier z;
identifier pdev;
expression e;
@@

rfn(struct platform_device *pdev) { ... when any
z = platform_get_resource(pdev, IORESOURCE_MEM, 0)
... when != z = e
    when != &z
free(z->start,...)
...
}

@remg depends on remge@
identifier virtual.rfn, virtual.free;
identifier z;
identifier pdev;
position p3;
expression e;
@@

rfn(struct platform_device *pdev) {
<... when strict
z = platform_get_resource(pdev, IORESOURCE_MEM, 0)
... when strict
    when != z = e
    when != &z
free@p3(z->start,...)
...>
}

@badg@
identifier virtual.free;
position p != {prbg.p2,remg.p3};
@@

free@p(...)

@modifg depends on remg && !badg@
expression x;
identifier prbg.pdev,virtual.alloc,virtual.free,virtual.devm_alloc;
expression list args;
position prbg.p1,prbg.p2,remg.p3;
@@

(
- free@p2(...);
|
- free@p3(...);
|
- alloc@p1(
+ devm_alloc(&pdev->dev,
   x,args)
)

// ---------------------------------------------------------------------
// cleanup, if the drvdata was only used to enable the free
// probably only relevant for kmalloc/kzalloc

@dclean depends on modif || modifx || modifg@
identifier virtual.rfn, pdev, i;
type T;
@@

rfn(struct platform_device *pdev) { ...
(
- T i = platform_get_drvdata(pdev);
|
- T i = dev_get_drvdata(&pdev->drv);
|
- T i;
  ... when != i
(
- i = platform_get_drvdata(pdev);
|
- i = dev_get_drvdata(&pdev->drv);
)
)
... when != i
}

@rclean depends on modif || modifx || modifg@
identifier virtual.rfn, pdev, i;
type T;
@@

rfn(struct platform_device *pdev) { ...
(
- T i = platform_get_resource(pdev,...);
|
- T i;
  ... when != i
- i = platform_get_resource(pdev,...);
)
... when != i
}

// ---------------------------------------------------------------------
// cleanup empty ifs, etc

@depends on modif || modifx || modifg@
identifier probe.pfn;
@@

pfn(...) { <...
- if (...) {}
...> }

@depends on modif || modifx || modifg@
identifier virtual.rfn;
@@

rfn(...) { <...
- if (...) {}
...> }

@depends on modif || modifx || modifg@
identifier probe.pfn;
expression ret,e;
@@

pfn(...) { <...
+ return
- ret =
 e;
- return ret;
...> }

@depends on modif || modifx || modifg@
identifier virtual.rfn;
expression ret,e;
@@

rfn(...) { <...
+ return
- ret =
 e;
- return ret;
...> }

// ---------------------------------------------------------------------

// this is likely to leave dead code, if l: is preceded by a return
// because we are control-flow based, there is no way to match on that
@depends on labelled_return && (modif || modifx || modifg)@
identifier l,l1,l2;
expression e;
statement S;
identifier probe.pfn;
identifier i;
statement S1,S2;
@@

pfn(...) { <...
- goto l;
+ goto l2;
...
-l:
<... when != S
     when any
l1:
...>
l2:
(
 (<+...i...+>);
|
 if (...) S1 else S2
|
 while (...) S1
|
 for (...;...;...) S1
|
 return e;
)
...> }

@depends on !labelled_return && (modif || modifx || modifg)@
identifier l,l1,l2;
expression e;
statement S;
identifier probe.pfn;
identifier i;
statement S1,S2;
@@

pfn(...) { <...
(
- goto l;
+ goto l2;
...
-l:
<... when != S
     when any
l1:
...>
l2:
(
 (<+...i...+>);
|
 if (...) S1 else S2
|
 while (...) S1
|
 for (...;...;...) S1
)
|
- goto l;
+ return e;
...
-l:
<... when != S
     when any
l1:
...>
return e;
)
...> }

