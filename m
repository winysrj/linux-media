Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40162 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751947AbcJEOrF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 10:47:05 -0400
Date: Wed, 5 Oct 2016 16:47:00 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Daniel Vetter <daniel@ffwll.ch>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, linux-metag@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        linux-mtd@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-clk@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>, drbd-dev@lists.linbit.com
Subject: Re: [PATCH 00/15] improve function-level documentation
In-Reply-To: <CAKMK7uHT3FutHQuQQ3iwXmYbidB3AOs7AxnpaJD4MTqy0-QehQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1610051645310.3568@hadrien>
References: <1475351192-27079-1-git-send-email-Julia.Lawall@lip6.fr> <CAKMK7uHT3FutHQuQQ3iwXmYbidB3AOs7AxnpaJD4MTqy0-QehQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 5 Oct 2016, Daniel Vetter wrote:

> Jani Nikula has a patch with a scrip to make the one kernel-doc parser
> into a lint/checker pass over the entire kernel. I think that'd would
> be more robust instead of trying to approximate the real kerneldoc
> parser. Otoh that parser is a horror show of a perl/regex driven state
> machine ;-)

Sure.  To my recollection, I found around 2000 issues.  Many I ignored, eg
functions that simply have no documentation abuot the parameters,
functions that document their local variables, when these were more
interesting than the parameters etc.  But the set of patches is not
exhaustive with respect to the remaining interesting ones either.

julia

>
> Jani, can you pls digg out these patches? Can't find them right now ...
> -Daniel
>
>
> On Sat, Oct 1, 2016 at 9:46 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > These patches fix cases where the documentation above a function definition
> > is not consistent with the function header.  Issues are detected using the
> > semantic patch below (http://coccinelle.lip6.fr/).  Basically, the semantic
> > patch parses a file to find comments, then matches each function header,
> > and checks that the name and parameter list in the function header are
> > compatible with the comment that preceeds it most closely.
> >
> > // <smpl>
> > @initialize:ocaml@
> > @@
> >
> > let tbl = ref []
> > let fnstart = ref []
> > let success = Hashtbl.create 101
> > let thefile = ref ""
> > let parsed = ref []
> > let nea = ref []
> >
> > let parse file =
> >   thefile := List.nth (Str.split (Str.regexp "linux-next/") file) 1;
> >   let i = open_in file in
> >   let startline = ref 0 in
> >   let fn = ref "" in
> >   let ids = ref [] in
> >   let rec inside n =
> >     let l = input_line i in
> >     let n = n + 1 in
> >     match Str.split_delim (Str.regexp_string "*/") l with
> >       before::after::_ ->
> >         (if not (!fn = "")
> >         then tbl := (!startline,n,!fn,List.rev !ids)::!tbl);
> >         startline := 0;
> >         fn := "";
> >         ids := [];
> >         outside n
> >     | _ ->
> >         (match Str.split (Str.regexp "[ \t]+") l with
> >           "*"::name::rest ->
> >             let len = String.length name in
> >             (if !fn = "" && len > 2 && String.sub name (len-2) 2 = "()"
> >             then fn := String.sub name 0 (len-2)
> >             else if !fn = "" && (not (rest = [])) && List.hd rest = "-"
> >             then
> >               if String.get name (len-1) = ':'
> >               then fn := String.sub name 0 (len-1)
> >               else fn := name
> >             else if not(!fn = "") && len > 2 &&
> >               String.get name 0 = '@' && String.get name (len-1) = ':'
> >             then ids := (String.sub name 1 (len-2)) :: !ids);
> >         | _ -> ());
> >         inside n
> >   and outside n =
> >     let l = input_line i in
> >     let n = n + 1 in
> >     if String.length l > 2 && String.sub l 0 3 = "/**"
> >     then
> >       begin
> >         startline := n;
> >         inside n
> >       end
> >     else outside n in
> >   try outside 0 with End_of_file -> ()
> >
> > let hashadd tbl k v =
> >   let cell =
> >     try Hashtbl.find tbl k
> >     with Not_found ->
> >       let cell = ref [] in
> >       Hashtbl.add tbl k cell;
> >       cell in
> >   cell := v :: !cell
> >
> > @script:ocaml@
> > @@
> >
> > tbl := [];
> > fnstart := [];
> > Hashtbl.clear success;
> > parsed := [];
> > nea := [];
> > parse (List.hd (Coccilib.files()))
> >
> > @r@
> > identifier f;
> > position p;
> > @@
> >
> > f@p(...) { ... }
> >
> > @script:ocaml@
> > p << r.p;
> > f << r.f;
> > @@
> >
> > parsed := f :: !parsed;
> > fnstart := (List.hd p).line :: !fnstart
> >
> > @param@
> > identifier f;
> > type T;
> > identifier i;
> > parameter list[n] ps;
> > parameter list[n1] ps1;
> > position p;
> > @@
> >
> > f@p(ps,T i,ps1) { ... }
> >
> > @script:ocaml@
> > @@
> >
> > tbl := List.rev (List.sort compare !tbl)
> >
> > @script:ocaml@
> > p << param.p;
> > f << param.f;
> > @@
> >
> > let myline = (List.hd p).line in
> > let prevline =
> >   List.fold_left
> >     (fun prev x ->
> >       if x < myline
> >       then max x prev
> >       else prev)
> >     0 !fnstart in
> > let _ =
> >   List.exists
> >     (function (st,fn,nm,ids) ->
> >       if prevline < st && myline > st && prevline < fn && myline > fn
> >       then
> >         begin
> >           (if not (String.lowercase f = String.lowercase nm)
> >           then
> >             Printf.printf "%s:%d %s doesn't match preceding comment: %s\n"
> >               !thefile myline f nm);
> >           true
> >         end
> >       else false)
> >     !tbl in
> > ()
> >
> > @script:ocaml@
> > p << param.p;
> > n << param.n;
> > n1 << param.n1;
> > i << param.i;
> > f << param.f;
> > @@
> >
> > let myline = (List.hd p).line in
> > let prevline =
> >   List.fold_left
> >     (fun prev x ->
> >       if x < myline
> >       then max x prev
> >       else prev)
> >     0 !fnstart in
> > let _ =
> >   List.exists
> >     (function (st,fn,nm,ids) ->
> >       if prevline < st && myline > st && prevline < fn && myline > fn
> >       then
> >         begin
> >           (if List.mem i ids then hashadd success (st,fn,nm) i);
> >           (if ids = [] (* arg list seems not obligatory *)
> >           then ()
> >           else if not (List.mem i ids)
> >           then
> >             Printf.printf "%s:%d %s doesn't appear in ids: %s\n"
> >               !thefile myline i (String.concat " " ids)
> >           else if List.length ids <= n || List.length ids <= n1
> >           then
> >             (if not (List.mem f !nea)
> >             then
> >               begin
> >                 nea := f :: !nea;
> >                 Printf.printf "%s:%d %s not enough args\n" !thefile myline f;
> >               end)
> >           else
> >             let foundid = List.nth ids n in
> >             let efoundid = List.nth (List.rev ids) n1 in
> >             if not(foundid = i || efoundid = i)
> >             then
> >               Printf.printf "%s:%d %s wrong arg in position %d: %s\n"
> >                 !thefile myline i n foundid);
> >           true
> >         end
> >       else false)
> >     !tbl in
> > ()
> >
> > @script:ocaml@
> > @@
> > List.iter
> >   (function (st,fn,nm,ids) ->
> >     if List.mem nm !parsed
> >     then
> >       let entry =
> >         try !(Hashtbl.find success (st,fn,nm))
> >         with Not_found -> [] in
> >       List.iter
> >         (fun id ->
> >           if not (List.mem id entry) && not (id = "...")
> >           then Printf.printf "%s:%d %s not used\n" !thefile st id)
> >         ids)
> >   !tbl
> > // </smpl>
> >
> >
> > ---
> >
> >  drivers/clk/keystone/pll.c               |    4 ++--
> >  drivers/clk/sunxi/clk-mod0.c             |    2 +-
> >  drivers/clk/tegra/cvb.c                  |   10 +++++-----
> >  drivers/dma-buf/sw_sync.c                |    6 +++---
> >  drivers/gpu/drm/gma500/intel_i2c.c       |    3 +--
> >  drivers/gpu/drm/omapdrm/omap_drv.c       |    4 ++--
> >  drivers/irqchip/irq-metag-ext.c          |    1 -
> >  drivers/irqchip/irq-vic.c                |    1 -
> >  drivers/mfd/tc3589x.c                    |    4 ++--
> >  drivers/power/supply/ab8500_fg.c         |    8 ++++----
> >  drivers/power/supply/abx500_chargalg.c   |    1 +
> >  drivers/power/supply/intel_mid_battery.c |    2 +-
> >  drivers/power/supply/power_supply_core.c |    4 ++--
> >  fs/crypto/crypto.c                       |    4 ++--
> >  fs/crypto/fname.c                        |    4 ++--
> >  fs/ubifs/file.c                          |    2 +-
> >  fs/ubifs/gc.c                            |    2 +-
> >  fs/ubifs/lprops.c                        |    2 +-
> >  fs/ubifs/lpt_commit.c                    |    4 +---
> >  fs/ubifs/replay.c                        |    2 +-
> >  lib/kobject_uevent.c                     |    6 +++---
> >  lib/lru_cache.c                          |    4 ++--
> >  lib/nlattr.c                             |    2 +-
> >  23 files changed, 39 insertions(+), 43 deletions(-)
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
