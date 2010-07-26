Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33289 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0GZTdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:33:25 -0400
From: "Sin, David" <davidsin@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <rmk@arm.linux.org.uk>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Ramachandra, Ravikiran" <r.ramachandra@ti.com>,
	"Molnar, Lajos" <molnar@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 26 Jul 2010 14:33:03 -0500
Subject: RE: [RFC 3/8] TILER-DMM: Sample TCM implementation: Simple TILER
 Allocator
Message-ID: <513FF747EED39B4AADBB4D6C9D9F9F7903D63B9DCE@dlee02.ent.ti.com>
References: <1279927348-21750-1-git-send-email-davidsin@ti.com>
 <1279927348-21750-2-git-send-email-davidsin@ti.com>
 <1279927348-21750-3-git-send-email-davidsin@ti.com>
 <1279927348-21750-4-git-send-email-davidsin@ti.com>
 <EAF47CD23C76F840A9E7FCE10091EFAB02C6255354@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02C6255354@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Comments acknowledged.  Adding in media lists also.

-David

-----Original Message-----
From: Shilimkar, Santosh
Sent: Saturday, July 24, 2010 2:13 AM
To: Sin, David; linux-arm-kernel@lists.arm.linux.org.uk; linux-omap@vger.kernel.org; Tony Lindgren; Russell King
Cc: Kanigeri, Hari; Ohad Ben-Cohen; Hiremath, Vaibhav; Ramachandra, Ravikiran; Molnar, Lajos
Subject: RE: [RFC 3/8] TILER-DMM: Sample TCM implementation: Simple TILER Allocator

> -----Original Message-----
> From: Sin, David
> Sent: Saturday, July 24, 2010 4:52 AM
> To: linux-arm-kernel@lists.arm.linux.org.uk; linux-omap@vger.kernel.org;
> Tony Lindgren; Russell King
> Cc: Kanigeri, Hari; Ohad Ben-Cohen; Hiremath, Vaibhav; Shilimkar, Santosh;
> Ramachandra, Ravikiran; Molnar, Lajos; Sin, David
> Subject: [RFC 3/8] TILER-DMM: Sample TCM implementation: Simple TILER
> Allocator
>
> From: Ravi Ramachandra <r.ramachandra@ti.com>
>
> This patch implements a simple TILER Container Manager.
>
> Signed-off-by: Ravi Ramachandra <r.ramachandra@ti.com>
> Signed-off-by: Lajos Molnar <molnar@ti.com>
> Signed-off-by: David Sin <davidsin@ti.com>
> ---
>  drivers/media/video/tiler/tcm/Makefile    |    1 +
>  drivers/media/video/tiler/tcm/_tcm-sita.h |   64 ++++
Why is such a header file name. Can't you club
>  drivers/media/video/tiler/tcm/tcm-sita.c  |  459
> +++++++++++++++++++++++++++++
>  drivers/media/video/tiler/tcm/tcm-sita.h  |   37 +++
You should club _tcm-sita.h and tcm-sita.h together
>  4 files changed, 561 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tiler/tcm/Makefile
>  create mode 100644 drivers/media/video/tiler/tcm/_tcm-sita.h
>  create mode 100644 drivers/media/video/tiler/tcm/tcm-sita.c
>  create mode 100644 drivers/media/video/tiler/tcm/tcm-sita.h
>
> diff --git a/drivers/media/video/tiler/tcm/Makefile
> b/drivers/media/video/tiler/tcm/Makefile
> new file mode 100644
> index 0000000..8434607
> --- /dev/null
> +++ b/drivers/media/video/tiler/tcm/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_TI_TILER) += tcm-sita.o
> diff --git a/drivers/media/video/tiler/tcm/_tcm-sita.h
> b/drivers/media/video/tiler/tcm/_tcm-sita.h
> new file mode 100644
> index 0000000..4ede1ab
> --- /dev/null
> +++ b/drivers/media/video/tiler/tcm/_tcm-sita.h
> @@ -0,0 +1,64 @@
> +/*
> + * _tcm_sita.h
> + *
> + * SImple Tiler Allocator (SiTA) private structures.
> + *
> + * Author: Ravi Ramachandra <r.ramachandra@ti.com>
> + *
> + * Copyright (C) 2009-2010 Texas Instruments, Inc.
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#ifndef _TCM_SITA_H
> +#define _TCM_SITA_H
> +
> +#include "../tcm.h"
Header inclusion
> +
> +/* length between two coordinates */
> +#define LEN(a, b) ((a) > (b) ? (a) - (b) + 1 : (b) - (a) + 1)
> +
> +enum criteria {
> +     CR_MAX_NEIGHS           = 0x01,
> +     CR_FIRST_FOUND          = 0x10,
> +     CR_BIAS_HORIZONTAL      = 0x20,
> +     CR_BIAS_VERTICAL        = 0x40,
> +     CR_DIAGONAL_BALANCE     = 0x80
> +};
> +
> +/* nearness to the beginning of the search field from 0 to 1000 */
> +struct nearness_factor {
> +     s32 x;
> +     s32 y;
> +};
> +
> +/*
> + * Statistics on immediately neighboring slots.  Edge is the number of
> + * border segments that are also border segments of the scan field.  Busy
> + * refers to the number of neighbors that are occupied.
> + */
> +struct neighbor_stats {
> +     u16 edge;
> +     u16 busy;
> +};
> +
> +/* structure to keep the score of a potential allocation */
> +struct score {
> +     struct nearness_factor  f;
> +     struct neighbor_stats   n;
> +     struct tcm_area         a;
> +     u16    neighs;          /* number of busy neighbors */
> +};
> +
> +struct sita_pvt {
> +     struct mutex mtx;
> +     struct tcm_area ***map; /* pointers to the parent area for each slot
> */
> +};
> +
> +#endif
> diff --git a/drivers/media/video/tiler/tcm/tcm-sita.c
> b/drivers/media/video/tiler/tcm/tcm-sita.c
> new file mode 100644
> index 0000000..93be3e6
> --- /dev/null
> +++ b/drivers/media/video/tiler/tcm/tcm-sita.c
> @@ -0,0 +1,459 @@
> +/*
> + * tcm-sita.c
> + *
> + * SImple Tiler Allocator (SiTA): 2D and 1D allocation(reservation)
> algorithm
> + *
> + * Authors: Ravi Ramachandra <r.ramachandra@ti.com>,
> + *          Lajos Molnar <molnar@ti.com>
> + *
> + * Copyright (C) 2009-2010 Texas Instruments, Inc.
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + *
> + */
> +#include <linux/slab.h>
> +
> +#include "_tcm-sita.h"
> +#include "tcm-sita.h"
> +
> +#define TCM_ALG_NAME "tcm_sita"
> +#include "tcm-utils.h"
> +
> +#define ALIGN_DOWN(value, align) ((value) & ~((align) - 1))
> +
> +/* Individual selection criteria for different scan areas */
> +static s32 CR_L2R_T2B = CR_BIAS_HORIZONTAL;
> +
> +/*********************************************
> + *   TCM API - Sita Implementation
> + *********************************************/
Commenting style
> +static s32 sita_reserve_2d(struct tcm *tcm, u16 h, u16 w, u8 align,
> +                        struct tcm_area *area);
> +static s32 sita_free(struct tcm *tcm, struct tcm_area *area);
> +static void sita_deinit(struct tcm *tcm);
> +
> +/*********************************************
> + *   Main Scanner functions
> + *********************************************/
ditto
> +static s32 scan_areas_and_find_fit(struct tcm *tcm, u16 w, u16 h, u16
> align,
> +                                struct tcm_area *area);
> +
> +static s32 scan_l2r_t2b(struct tcm *tcm, u16 w, u16 h, u16 align,
> +                     struct tcm_area *field, struct tcm_area *area);
> +
> +/*********************************************
> + *   Support Infrastructure Methods
> + *********************************************/
ditto
> +static s32 is_area_free(struct tcm_area ***map, u16 x0, u16 y0, u16 w,
> u16 h);
> +
> +static s32 update_candidate(struct tcm *tcm, u16 x0, u16 y0, u16 w, u16
> h,
> +                         struct tcm_area *field, s32 criteria,
> +                         struct score *best);
> +
> +static void get_nearness_factor(struct tcm_area *field,
> +                             struct tcm_area *candidate,
> +                             struct nearness_factor *nf);
> +
> +static void get_neighbor_stats(struct tcm *tcm, struct tcm_area *area,
> +                            struct neighbor_stats *stat);
> +
> +static void fill_area(struct tcm *tcm,
> +                             struct tcm_area *area, struct tcm_area *parent);
> +
> +/*********************************************/
> +
> +/*********************************************
> + *   Utility Methods
> + *********************************************/
> +struct tcm *sita_init(u16 width, u16 height, void *attr)
> +{
> +     struct tcm *tcm;
> +     struct sita_pvt *pvt;
> +     struct tcm_area area = {0};
> +     s32 i;
> +
> +     if (width == 0 || height == 0)
> +             return NULL;
> +
> +     tcm = kzalloc(sizeof(*tcm), GFP_KERNEL);
> +     pvt = kzalloc(sizeof(*pvt), GFP_KERNEL);
> +     if (!tcm || !pvt)
> +             goto error;
> +
> +     /* Updating the pointers to SiTA implementation APIs */
> +     tcm->height = height;
> +     tcm->width = width;
> +     tcm->reserve_2d = sita_reserve_2d;
> +     tcm->free = sita_free;
> +     tcm->deinit = sita_deinit;
> +     tcm->pvt = (void *)pvt;
> +
> +     mutex_init(&(pvt->mtx));
> +
> +     /* Creating tam map */
> +     pvt->map = kzalloc(sizeof(*pvt->map) * tcm->width, GFP_KERNEL);
> +     if (!pvt->map)
> +             goto error;
> +
> +     for (i = 0; i < tcm->width; i++) {
> +             pvt->map[i] =
> +                     kzalloc(sizeof(**pvt->map) * tcm->height,
> +                                                             GFP_KERNEL);
> +             if (pvt->map[i] == NULL) {
> +                     while (i--)
> +                             kfree(pvt->map[i]);
> +                     kfree(pvt->map);
> +                     goto error;
> +             }
> +     }
> +
> +     mutex_lock(&(pvt->mtx));
> +     assign(&area, 0, 0, width - 1, height - 1);
> +     fill_area(tcm, &area, NULL);
> +     mutex_unlock(&(pvt->mtx));
> +     return tcm;
> +
> +error:
> +     kfree(tcm);
> +     kfree(pvt);
If only one of the allocation was successful, then you
are freeing a NULL pointer.
May be have something like this

        tcm = kzalloc(sizeof(*tcm), GFP_KERNEL);
        if (!tcm)
                goto error1;
        pvt = kzalloc(sizeof(*pvt), GFP_KERNEL);
        if (!pvt)
                goto error2;
        .
        .
        .
error1:
        kfree(tcm);
error2:
        kfree(pvt);

> +     return NULL;
> +}
> +
> +static void sita_deinit(struct tcm *tcm)
> +{
> +     struct sita_pvt *pvt = (struct sita_pvt *)tcm->pvt;
> +     struct tcm_area area = {0};
> +     s32 i;
> +
> +     area.p1.x = tcm->width - 1;
> +     area.p1.y = tcm->height - 1;
> +
> +     mutex_lock(&(pvt->mtx));
> +     fill_area(tcm, &area, NULL);
> +     mutex_unlock(&(pvt->mtx));
> +
> +     mutex_destroy(&(pvt->mtx));
> +
> +     for (i = 0; i < tcm->height; i++)
> +             kfree(pvt->map[i]);
> +     kfree(pvt->map);
> +     kfree(pvt);
> +}
> +
> +/**
> + * Reserve a 2D area in the container
> + *
> + * @param w  width
> + * @param h  height
> + * @param area       pointer to the area that will be populated with the
> reesrved
> + *           area
> + *
> + * @return 0 on success, non-0 error value on failure.
> + */
> +static s32 sita_reserve_2d(struct tcm *tcm, u16 h, u16 w, u8 align,
> +                        struct tcm_area *area)
> +{
> +     s32 ret;
> +     struct sita_pvt *pvt = (struct sita_pvt *)tcm->pvt;
> +
> +     /* not supporting more than 64 as alignment */
> +     if (align > 64)
> +             return -EINVAL;
> +
> +     /* we prefer 1, 32 and 64 as alignment */
> +     align = align <= 1 ? 1 : align <= 32 ? 32 : 64;
> +
> +     mutex_lock(&(pvt->mtx));
> +     ret = scan_areas_and_find_fit(tcm, w, h, align, area);
> +     if (!ret)
> +             /* update map */
> +             fill_area(tcm, area, area);
> +
> +     mutex_unlock(&(pvt->mtx));
> +     return ret;
> +}
> +
> +/**
> + * Unreserve a previously allocated 2D or 1D area
> + * @param area       area to be freed
> + * @return 0 - success
> + */
> +static s32 sita_free(struct tcm *tcm, struct tcm_area *area)
> +{
> +     struct sita_pvt *pvt = (struct sita_pvt *)tcm->pvt;
> +
> +     mutex_lock(&(pvt->mtx));
> +
> +     /* Clear the contents of the associated tiles in the map */
> +     fill_area(tcm, area, NULL);
> +
> +     mutex_unlock(&(pvt->mtx));
> +
> +     return 0;
> +}
> +
> +/**
> + * Note: In general the cordinates in the scan field area relevant to the
> can
> + * sweep directions. The scan origin (e.g. top-left corner) will always
> be
> + * the p0 member of the field.  Therfore, for a scan from top-left p0.x
> <= p1.x
> + * and p0.y <= p1.y; whereas, for a scan from bottom-right p1.x <= p0.x
> and p1.y
> + * <= p0.y
> + */
> +
> +/**
> + * Raster scan horizontally left to right from top to bottom to find a
> place for
> + * a 2D area of given size inside a scan field.
> + *
> + * @param w  width of desired area
> + * @param h  height of desired area
> + * @param align      desired area alignment
> + * @param area       pointer to the area that will be set to the best
> position
> + * @param field      area to scan (inclusive)
> + *
> + * @return 0 on success, non-0 error value on failure.
> + */
> +static s32 scan_l2r_t2b(struct tcm *tcm, u16 w, u16 h, u16 align,
> +                     struct tcm_area *field, struct tcm_area *area)
> +{
> +     s32 x, y;
> +     s16 start_x, end_x, start_y, end_y;
> +     struct tcm_area ***map = ((struct sita_pvt *)tcm->pvt)->map;
> +     struct score best = {{0}, {0}, {0}, 0};
> +
> +     PA(2, "scan_l2r_t2b:", field);
> +
> +     start_x = field->p0.x;
> +     end_x = field->p1.x;
> +     start_y = field->p0.y;
> +     end_y = field->p1.y;
> +
> +     /* check scan area co-ordinates */
> +     if (field->p1.x < field->p0.x ||
> +         field->p1.y < field->p0.y)
> +             return -EINVAL;
> +
> +     /* check if allocation would fit in scan area */
> +     if (w > LEN(end_x, start_x) || h > LEN(end_y, start_y))
> +             return -ENOSPC;
> +
> +     start_x = ALIGN(start_x, align);
> +
> +     /* check if allocation would still fit in scan area */
> +     if (w > LEN(end_x, start_x))
> +             return -ENOSPC;
> +
> +     /* adjust end_x and end_y, as allocation would not fit beyond */
> +     end_x = end_x - w + 1; /* + 1 to be inclusive */
> +     end_y = end_y - h + 1;
> +
> +     P2("ali=%d x=%d..%d y=%d..%d", align, start_x, end_x, start_y,
> end_y);
> +
> +     /* scan field top-to-bottom, left-to-right */
> +     for (y = start_y; y <= end_y; y++) {
> +             for (x = start_x; x <= end_x; x += align) {
> +                     if (is_area_free(map, x, y, w, h)) {
> +                             P3("found shoulder: %d,%d", x, y);
> +
> +                             /* update best candidate */
> +                             if (update_candidate(tcm, x, y, w, h, field,
> +                                                     CR_L2R_T2B, &best))
> +                                     goto done;
> +                             break;
> +                     } else if (map[x][y]) {
> +                             /* step over 2D areas */
> +                             x = ALIGN_DOWN(map[x][y]->p1.x, align);
> +                             P3("moving to: %d,%d", x, y);
> +                     }
> +             }
> +     }
> +
> +     if (!best.a.tcm)
> +             return -ENOSPC;
> +done:
> +     assign(area, best.a.p0.x, best.a.p0.y, best.a.p1.x, best.a.p1.y);
> +     return 0;
> +}
> +
> +/**
> + * Find a place for a 2D area of given size inside a scan field based on
> its
> + * alignment needs.
> + *
> + * @param w  width of desired area
> + * @param h  height of desired area
> + * @param align      desired area alignment
> + * @param area       pointer to the area that will be set to the best
> position
> + *
> + * @return 0 on success, non-0 error value on failure.
> + */
> +static s32 scan_areas_and_find_fit(struct tcm *tcm, u16 w, u16 h, u16
> align,
> +                                struct tcm_area *area)
> +{
> +     struct tcm_area field = {0};
> +
> +     /* scan whole container left to right, top to bottom */
> +     assign(&field, 0, 0, tcm->width - 1, tcm->height - 1);
> +     return scan_l2r_t2b(tcm, w, h, align, &field, area);
> +}
> +
> +/* check if an entire area is free */
> +static s32 is_area_free(struct tcm_area ***map, u16 x0, u16 y0, u16 w,
> u16 h)
> +{
> +     u16 x = 0, y = 0;
> +     for (y = y0; y < y0 + h; y++) {
> +             for (x = x0; x < x0 + w; x++) {
> +                     if (map[x][y])
> +                             return false;
> +             }
> +     }
> +     return true;
> +}
> +
> +/* fills an area with a parent tcm_area */
> +static void fill_area(struct tcm *tcm, struct tcm_area *area,
> +                     struct tcm_area *parent)
> +{
> +     s32 x, y;
> +     struct sita_pvt *pvt = (struct sita_pvt *)tcm->pvt;
> +
> +     PA(2, "fill 2d area", area);
> +     for (x = area->p0.x; x <= area->p1.x; ++x)
> +             for (y = area->p0.y; y <= area->p1.y; ++y)
> +                     pvt->map[x][y] = parent;
> +}
> +
> +/**
> + * Compares a candidate area to the current best area, and if it is a
> better
> + * fit, it updates the best to this one.
> + *
> + * @param x0, y0, w, h               top, left, width, height of candidate area
> + * @param field                      scan field
> + * @param criteria           scan criteria
> + * @param best                       best candidate and its scores
> + *
> + * @return 1 (true) if the candidate area is known to be the final best,
> so no
> + * more searching should be performed
> + */
> +static s32 update_candidate(struct tcm *tcm, u16 x0, u16 y0, u16 w, u16
> h,
> +                         struct tcm_area *field, s32 criteria,
> +                         struct score *best)
> +{
> +     struct score me;        /* score for area */
> +
> +     /*
> +      * If first found is enabled then we stop looking
> +      * NOTE: For horizontal bias we always give the first found, because
> our
> +      * scan is horizontal-raster-based and the first candidate will
> always
> +      * have the horizontal bias.
> +      */
> +     bool first = criteria & (CR_FIRST_FOUND | CR_BIAS_HORIZONTAL);
> +
> +     assign(&me.a, x0, y0, x0 + w - 1, y0 + h - 1);
> +
> +     /* calculate score for current candidate */
> +     if (!first) {
> +             get_neighbor_stats(tcm, &me.a, &me.n);
> +             me.neighs = me.n.edge + me.n.busy;
> +             get_nearness_factor(field, &me.a, &me.f);
> +     }
> +
> +     /* the 1st candidate is always the best */
> +     if (!best->a.tcm)
> +             goto better;
> +
> +     /* see if this are is better than the best so far */
> +
> +     /* neighbor check */
> +     if ((criteria & CR_MAX_NEIGHS) &&
> +             me.neighs > best->neighs)
> +             goto better;
> +
> +     /* vertical bias check */
> +     if ((criteria & CR_BIAS_VERTICAL) &&
> +     /*
> +      * NOTE: not checking if lengths are same, because that does not
> +      * find new shoulders on the same row after a fit
> +      */
> +             LEN(me.a.p0.y, field->p0.y) >
> +             LEN(best->a.p0.y, field->p0.y))
> +             goto better;
> +
> +     /* diagonal balance check */
> +     if ((criteria & CR_DIAGONAL_BALANCE) &&
> +             best->neighs <= me.neighs &&
> +             (best->neighs < me.neighs ||
> +              /* this implies that neighs and occupied match */
> +              best->n.busy < me.n.busy ||
> +              (best->n.busy == me.n.busy &&
> +               /* check the nearness factor */
> +               best->f.x + best->f.y > me.f.x + me.f.y)))
> +             goto better;
> +
> +     /* not better, keep going */
> +     return 0;
> +
> +better:
> +     /* save current area as best */
> +     memcpy(best, &me, sizeof(me));
> +     best->a.tcm = tcm;
> +     return first;
> +}
> +
> +/**
> + * Calculate the nearness factor of an area in a search field.  The
> nearness
> + * factor is smaller if the area is closer to the search origin.
> + */
> +static void get_nearness_factor(struct tcm_area *field, struct tcm_area
> *area,
> +                             struct nearness_factor *nf)
> +{
> +     /**
> +      * Using signed math as field coordinates may be reversed if
> +      * search direction is right-to-left or bottom-to-top.
> +      */
> +     nf->x = (s32)(area->p0.x - field->p0.x) * 1000 /
> +             (field->p1.x - field->p0.x);
> +     nf->y = (s32)(area->p0.y - field->p0.y) * 1000 /
> +             (field->p1.y - field->p0.y);
> +}
> +
> +/* get neighbor statistics */
> +static void get_neighbor_stats(struct tcm *tcm, struct tcm_area *area,
> +                      struct neighbor_stats *stat)
> +{
> +     s16 x = 0, y = 0;
> +     struct sita_pvt *pvt = (struct sita_pvt *)tcm->pvt;
> +
> +     /* Clearing any exisiting values */
> +     memset(stat, 0, sizeof(*stat));
> +
> +     /* process top & bottom edges */
> +     for (x = area->p0.x; x <= area->p1.x; x++) {
> +             if (area->p0.y == 0)
> +                     stat->edge++;
> +             else if (pvt->map[x][area->p0.y - 1])
> +                     stat->busy++;
> +
> +             if (area->p1.y == tcm->height - 1)
> +                     stat->edge++;
> +             else if (pvt->map[x][area->p1.y + 1])
> +                     stat->busy++;
> +     }
> +
> +     /* process left & right edges */
> +     for (y = area->p0.y; y <= area->p1.y; ++y) {
> +             if (area->p0.x == 0)
> +                     stat->edge++;
> +             else if (pvt->map[area->p0.x - 1][y])
> +                     stat->busy++;
> +
> +             if (area->p1.x == tcm->width - 1)
> +                     stat->edge++;
> +             else if (pvt->map[area->p1.x + 1][y])
> +                     stat->busy++;
> +     }
> +}
> diff --git a/drivers/media/video/tiler/tcm/tcm-sita.h
> b/drivers/media/video/tiler/tcm/tcm-sita.h
> new file mode 100644
> index 0000000..ab2d05b
> --- /dev/null
> +++ b/drivers/media/video/tiler/tcm/tcm-sita.h
> @@ -0,0 +1,37 @@
> +/*
> + * tcm_sita.h
> + *
> + * SImple Tiler Allocator (SiTA) interface.
> + *
> + * Author: Ravi Ramachandra <r.ramachandra@ti.com>
> + *
> + * Copyright (C) 2009-2010 Texas Instruments, Inc.
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#ifndef TCM_SITA_H
> +#define TCM_SITA_H
> +
> +#include "../tcm.h"
> +
> +/**
> + * Create a SiTA tiler container manager.
> + *
> + * @param width  Container width
> + * @param height Container height
> + * @param attr   unused
> + *
> + * @return TCM instance
> + */
> +struct tcm *sita_init(u16 width, u16 height, void *attr);
> +
> +TCM_INIT(sita_init, void);
Function name appears like a macro.
> +
> +#endif /* TCM_SITA_H_ */
> --
> 1.6.3.3

